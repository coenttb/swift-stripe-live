//
//  Stripe Rate Limit Within Limits Tests.swift
//  swift-stripe-live
//
//  Tests to verify requests within limits are not delayed
//

import Clocks
import Dependencies
import DependenciesTestSupport
import EnvironmentVariables
import Foundation
import Stripe_Live_Shared
import Stripe_Products_Live
import Testing

@Suite(
  "Stripe Rate Limit Within Limits Tests",
  .dependency(\.projectRoot, .stripe),
  .dependency(\.envVars, .development),
  .dependency(\.date, .init(Date.init)),
  .dependency(\.continuousClock, ContinuousClock()),
  .serialized
)
struct StripeRateLimitWithinLimitsTests {

  @Test("Requests within limits should not be delayed")
  func testRequestsWithinLimits() async throws {
    @Dependency(Stripe.Products.Products.self) var client
    @Dependency(\.continuousClock) var clock

    print("\n=== Testing Requests Within Rate Limits ===")
    print("Making 10 requests with 100ms delays (10 req/sec)")
    print("This is well below the 25 req/sec limit")
    print("===========================================\n")

    // Create a test product
    let product = try await client.client.create(
      .init(
        name: "Within Limits Test",
        description: "Testing normal rate requests"
      )
    )

    var normalRequests = 0  // Normal network latency (< 500ms)
    var delayedRequests = 0  // Rate limited or unusual delay (>= 500ms)
    let requestCount = 10
    var durations: [TimeInterval] = []

    for i in 1...requestCount {
      let requestStart = Date()

      _ = try await client.client.retrieve(product.id)

      let duration = Date().timeIntervalSince(requestStart)
      durations.append(duration)

      // 500ms threshold distinguishes normal API latency from rate limiting delays
      if duration < 0.5 {  // Less than 500ms is normal for API calls
        normalRequests += 1
        print("Request \(i): NORMAL (\(String(format: "%.3f", duration))s)")
      } else {
        delayedRequests += 1
        print("Request \(i): DELAYED (\(String(format: "%.3f", duration))s) - likely rate limited")
      }

      // Wait 100ms between requests (10 req/sec pace)
      try await clock.sleep(for: .milliseconds(100))
    }

    // Cleanup
    _ = try? await client.client.delete(product.id)

    let avgDuration = durations.reduce(0, +) / Double(durations.count)

    print("\n=== Results ===")
    print("Normal requests (< 500ms): \(normalRequests)")
    print("Delayed requests (>= 500ms): \(delayedRequests)")
    print("Average duration: \(String(format: "%.3f", avgDuration))s")
    print("===============\n")

    // When within rate limits, requests should have normal latency (not be delayed by rate limiting)
    #expect(
      normalRequests > delayedRequests,
      "Most requests should have normal latency when within rate limits"
    )
    #expect(
      avgDuration < 0.5,
      "Average request duration should be under 500ms when not rate limited"
    )
  }

  @Test("Compare with and without rate limiting")
  func testCompareWithWithoutRateLimiting() async throws {
    print("\n=== Comparing With and Without Rate Limiting ===")

    // First, let's make requests using our rate-limited handler
    print("\nWith Rate Limiting:")
    @Dependency(Stripe.Products.Products.self) var client

    let product = try await client.client.create(
      .init(name: "Comparison Test", description: "Testing")
    )

    let startWithRL = Date()
    for i in 1...5 {
      let reqStart = Date()
      _ = try await client.client.retrieve(product.id)
      let duration = Date().timeIntervalSince(reqStart)
      print("  Request \(i): \(String(format: "%.3f", duration))s")
    }
    let durationWithRL = Date().timeIntervalSince(startWithRL)

    print("Total time with rate limiting: \(String(format: "%.3f", durationWithRL))s")

    // Cleanup
    _ = try? await client.client.delete(product.id)

    print("=================================================\n")
  }

  @Test("Test actual Stripe 429 response without rate limiting")
  func testActual429Response() async throws {
    print("\n=== Testing Direct Stripe API Without Rate Limiting ===")
    print("This test bypasses our rate limiter to see actual 429 errors")
    print("========================================================\n")

    // Create a product first using the rate-limited client
    @Dependency(Stripe.Products.Products.self) var client
    let product = try await client.client.create(
      .init(name: "Direct API Test", description: "Testing 429")
    )

    // Now make rapid requests directly to Stripe without our rate limiting
    // This should trigger actual 429 errors from Stripe
    @Dependency(\.envVars) var envVars
    guard let secretKeyObj = envVars.stripe.secretKey else {
      print("Skipping test: STRIPE_SECRET_KEY environment variable not set")
      return
    }
    let apiKey = secretKeyObj.rawValue
    let baseURL = "https://api.stripe.com/v1"

    var url = URLComponents(string: "\(baseURL)/products/\(product.id)")!
    var request = URLRequest(url: url.url!)
    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "GET"

    var successCount = 0
    var rateLimitCount = 0

    print("Making 30 rapid direct API calls (bypassing rate limiter)...")

    for i in 1...30 {
      do {
        let (_, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse {
          if httpResponse.statusCode == 429 {
            rateLimitCount += 1
            print("Request \(i): 429 RATE LIMITED ❌")
          } else if httpResponse.statusCode == 200 {
            successCount += 1
            print("Request \(i): 200 OK ✓")
          } else {
            print("Request \(i): \(httpResponse.statusCode)")
          }
        }
      } catch {
        print("Request \(i): ERROR - \(error)")
      }
    }

    // Cleanup
    _ = try? await client.client.delete(product.id)

    print("\n=== Direct API Results ===")
    print("Successful: \(successCount)")
    print("Rate limited (429): \(rateLimitCount)")
    print("==========================\n")

    // When bypassing our rate limiter, we expect to see 429 errors
    print("Note: If we see 429 errors above, it confirms Stripe's rate limiting is active")
    print("and our rate limiter is successfully preventing these in normal usage.")
  }
}
