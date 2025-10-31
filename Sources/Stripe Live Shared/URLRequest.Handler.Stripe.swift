////
////  File.swift
////  swift-stripe-live
////
////  Created by Coen ten Thije Boonkkamp on 04/08/2025.
////
//

import Clocks
import Dependencies
import Foundation
import ServerFoundation

// Note: Throttling is imported via ServerFoundation's @_exported import

extension URLRequest.Handler {
  package enum Stripe {}
}

/// Dependency key for Stripe throttled client that combines rate limiting and pacing
struct StripeThrottledClientKey: DependencyKey {
  static let liveValue = ThrottledClient<String>(
    rateLimiter: RateLimiter<String>(
      windows: [
        .seconds(1, maxAttempts: 100),
        .minutes(1, maxAttempts: 6000),  // Live mode: 100 requests/sec = 6000/min
        .hours(1, maxAttempts: 360000),  // Safety limit for live mode
      ],
      backoffMultiplier: 2.0
    ),
    pacer: RequestPacer<String>(
      targetRate: 100.0,  // Live mode: 100 req/sec with smooth pacing
      allowCatchUp: true  // Allow requests to catch up if behind schedule
    )
  )

  static let testValue = ThrottledClient<String>(
    rateLimiter: RateLimiter<String>(
      windows: [
        .seconds(1, maxAttempts: 25),
        .minutes(1, maxAttempts: 1500),  // Test mode: 25 requests/sec = 1500/min
        .hours(1, maxAttempts: 90000),  // Safety limit for test mode
      ],
      backoffMultiplier: 2.0
    ),
    pacer: RequestPacer<String>(
      targetRate: 25.0,  // Test mode: 25 req/sec with smooth pacing
      allowCatchUp: true  // Allow requests to catch up if behind schedule
    )
  )
}

extension DependencyValues {
  package var stripeThrottledClient: ThrottledClient<String> {
    get { self[StripeThrottledClientKey.self] }
    set { self[StripeThrottledClientKey.self] = newValue }
  }
}

extension URLRequest.Handler.Stripe: DependencyKey {

  package static var liveValue: URLRequest.Handler { Self.default() }

  package static var testValue: URLRequest.Handler { Self.default() }

  /// Default handler configuration shared between live and test values
  package static func `default`() -> URLRequest.Handler {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    // Don't use automatic snake_case conversion since our models have explicit CodingKeys
    // decoder.keyDecodingStrategy = .convertFromSnakeCase

    return withDependencies {
      $0.defaultSession = { request in
        try await performRateLimitedRequest(request)
      }
    } operation: {
      return .init(
        debug: false,
        decoder: decoder
      )
    }
  }

  private static func performRateLimitedRequest(
    _ request: URLRequest,
    retryCount: Int = 0,
    maxRetries: Int = 5
  ) async throws -> (Data, URLResponse) {
    @Dependency(\.continuousClock) var clock
    @Dependency(\.stripeThrottledClient) var throttledClient
    let rateLimitKey = "stripe-api"

    // Use ThrottledClient to check both rate limits and pacing
    let acquisitionResult = await throttledClient.acquire(rateLimitKey)

    if !acquisitionResult.canProceed {
      // We're rate limited, wait and retry
      if let retryAfter = acquisitionResult.retryAfter {
        let jitteredDelay = addJitter(to: min(retryAfter, 60))
        let waitDuration = Duration.seconds(jitteredDelay)
        try await clock.sleep(for: waitDuration)
      } else if let rateLimitResult = acquisitionResult.rateLimitResult,
        let nextAllowedAttempt = rateLimitResult.nextAllowedAttempt
      {
        // Use next allowed attempt time if retry after not provided
        let waitTime = nextAllowedAttempt.timeIntervalSinceNow
        if waitTime > 0 {
          let jitteredDelay = addJitter(to: min(waitTime, 60))
          let waitDuration = Duration.seconds(jitteredDelay)
          try await clock.sleep(for: waitDuration)
        }
      }

      // Retry after waiting
      return try await performRateLimitedRequest(
        request,
        retryCount: retryCount,
        maxRetries: maxRetries
      )
    }

    // Wait for the scheduled time to maintain proper pacing
    try await acquisitionResult.waitUntilReady()

    // Perform the actual request
    do {
      let (data, response) = try await URLSession.shared.data(for: request)

      // Check for rate limit response
      if let httpResponse = response as? HTTPURLResponse {
        if httpResponse.statusCode == 429 {
          // Extract rate limit reason for specific handling
          let rateLimitReason = httpResponse.value(forHTTPHeaderField: "Stripe-Rate-Limited-Reason")
            .flatMap(StripeRateLimitReason.init(rawValue:))

          // Record failure with appropriate strategy based on rate limit type
          if rateLimitReason?.useExponentialBackoff == true {
            await throttledClient.recordFailure(rateLimitKey)
          }

          // Check if we've exceeded max retries
          guard retryCount < maxRetries else {
            let reasonDescription = rateLimitReason?.rawValue ?? "unknown"
            throw URLError(
              .dataNotAllowed,
              userInfo: [
                NSLocalizedDescriptionKey:
                  "Rate limit exceeded after \(maxRetries) retries (reason: \(reasonDescription))"
              ]
            )
          }

          // Extract retry-after header if available
          let retryAfter =
            httpResponse.value(forHTTPHeaderField: "Retry-After")
            .flatMap(Double.init) ?? 1.0

          // Apply rate limit specific backoff strategy
          let baseDelay = calculateBackoffDelay(
            retryAfter: retryAfter,
            retryCount: retryCount,
            rateLimitReason: rateLimitReason
          )

          // Wait and retry with jitter to prevent thundering herd
          let jitteredDelay = addJitter(to: baseDelay)
          let waitDuration = Duration.seconds(min(jitteredDelay, 60))
          try await clock.sleep(for: waitDuration)

          return try await performRateLimitedRequest(
            request,
            retryCount: retryCount + 1,
            maxRetries: maxRetries
          )
        } else {
          // Successful request
          await throttledClient.recordSuccess(rateLimitKey)
        }
      }

      return (data, response)
    } catch {
      // Record failure for network errors
      await throttledClient.recordFailure(rateLimitKey)
      throw error
    }
  }

  /// Represents different types of Stripe rate limits
  private enum StripeRateLimitReason: String, CaseIterable {
    case globalConcurrency = "global-concurrency"
    case globalRate = "global-rate"
    case endpointConcurrency = "endpoint-concurrency"
    case endpointRate = "endpoint-rate"

    /// Returns the recommended backoff multiplier for this rate limit type
    var backoffMultiplier: Double {
      switch self {
      case .globalConcurrency:
        return 0.5  // Shorter backoff for concurrency limits
      case .globalRate:
        return 1.0  // Standard backoff for global rate limits
      case .endpointConcurrency:
        return 0.3  // Very short backoff for endpoint concurrency
      case .endpointRate:
        return 1.5  // Longer backoff for endpoint-specific rate limits
      }
    }

    /// Returns whether this rate limit type should use exponential backoff
    var useExponentialBackoff: Bool {
      switch self {
      case .globalConcurrency, .endpointConcurrency:
        return false  // Concurrency limits are temporary, linear backoff is better
      case .globalRate, .endpointRate:
        return true  // Rate limits benefit from exponential backoff
      }
    }
  }

  /// Calculates the backoff delay based on rate limit reason and retry count
  private static func calculateBackoffDelay(
    retryAfter: TimeInterval,
    retryCount: Int,
    rateLimitReason: StripeRateLimitReason?
  ) -> TimeInterval {
    guard let reason = rateLimitReason else {
      // Default behavior for unknown rate limit reasons
      return retryAfter
    }

    let baseDelay = retryAfter * reason.backoffMultiplier

    if reason.useExponentialBackoff {
      // Apply exponential backoff: delay = baseDelay * (2^retryCount)
      let exponentialDelay = baseDelay * pow(2.0, Double(retryCount))
      return min(exponentialDelay, 60.0)  // Cap at 60 seconds
    } else {
      // Use linear backoff for concurrency limits
      return min(baseDelay, 10.0)  // Cap at 10 seconds for concurrency issues
    }
  }

  /// Adds jitter to a delay value to prevent thundering herd problem
  /// Uses full jitter: random value between 0 and baseDelay
  /// This spreads out retry attempts across the full backoff window
  private static func addJitter(to baseDelay: TimeInterval) -> TimeInterval {
    // Full jitter: random value between 0 and baseDelay
    // This provides maximum distribution to prevent thundering herd
    return Double.random(in: 0...baseDelay)
  }
}
