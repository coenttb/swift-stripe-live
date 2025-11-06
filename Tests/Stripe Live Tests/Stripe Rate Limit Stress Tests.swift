//
//  Stripe Rate Limit Stress Tests.swift
//  swift-stripe-live
//
//  Aggressive tests to verify rate limiting handles Stripe's actual limits
//

import Clocks
import Dependencies
import DependenciesTestSupport
import EnvironmentVariables
import Foundation
import Stripe_Live_Shared
import Stripe_Products_Live
import Testing

struct RequestTiming {
    let index: Int
    let duration: TimeInterval
    let delayed: Bool
}

@Suite(
    "Stripe Rate Limit Stress Tests",
    .dependency(\.projectRoot, .stripe),
    .dependency(\.envVars, .development),
    .dependency(\.date, .init(Date.init)),
    .dependency(\.continuousClock, ContinuousClock())
)
struct StripeRateLimitStressTests {

    @Test("Should handle exceeding Stripe's test mode limit (25 req/sec)")
    func testExceedingStripeLimits() async throws {
        @Dependency(Stripe.Products.Products.self) var client
        @Dependency(\.continuousClock) var clock

        // Test mode limit is 25 requests/second
        // Let's try to make 50 requests in 1 second (2x the limit)
        let requestsPerSecond = 50
        let testDuration: TimeInterval = 1.0

        print("\n=== Stress Testing Stripe Rate Limits ===")
        print("Stripe test mode limit: 25 requests/second")
        print("Attempting: \(requestsPerSecond) requests in \(testDuration) second")
        print("=========================================\n")

        // Create a base product to work with
        let baseProduct = try await client.client.create(
            .init(
                name: "Rate Limit Stress Test",
                description: "Testing against actual Stripe limits"
            )
        )

        var successCount = 0
        var rateLimitErrors = 0
        var delayedRequests = 0
        let startTime = Date()

        // Track individual request timings
        var requestTimings: [RequestTiming] = []

        // Make requests as fast as possible
        for i in 1...requestsPerSecond {
            let requestStart = Date()

            do {
                // Use retrieve as it's a simple, fast operation
                _ = try await client.client.retrieve(baseProduct.id)

                let requestDuration = Date().timeIntervalSince(requestStart)
                let wasDelayed = requestDuration > 0.1  // Consider > 100ms as delayed

                if wasDelayed {
                    delayedRequests += 1
                    print(
                        "Request \(i): SUCCESS (delayed: \(String(format: "%.3f", requestDuration))s)"
                    )
                } else {
                    print(
                        "Request \(i): SUCCESS (fast: \(String(format: "%.3f", requestDuration))s)"
                    )
                }

                requestTimings.append(
                    RequestTiming(index: i, duration: requestDuration, delayed: wasDelayed)
                )
                successCount += 1

            } catch {
                let errorString = String(describing: error)
                if errorString.contains("429") || errorString.contains("rate_limit") {
                    rateLimitErrors += 1
                    print("Request \(i): RATE LIMITED (429)")
                } else {
                    print("Request \(i): ERROR - \(error)")
                }
            }
        }

        let totalDuration = Date().timeIntervalSince(startTime)
        let effectiveRequestsPerSecond = Double(successCount) / totalDuration

        // Cleanup
        _ = try? await client.client.delete(baseProduct.id)

        print("\n=== Stress Test Results ===")
        print("Total duration: \(String(format: "%.3f", totalDuration)) seconds")
        print("Successful requests: \(successCount)")
        print("Rate limit errors (429): \(rateLimitErrors)")
        print("Delayed requests: \(delayedRequests)")
        print(
            "Effective rate: \(String(format: "%.1f", effectiveRequestsPerSecond)) requests/second"
        )
        print("===========================\n")

        // Analysis
        if delayedRequests > 0 {
            let avgDelay =
                requestTimings.filter { $0.delayed }.map { $0.duration }.reduce(0, +)
                / Double(delayedRequests)
            print(
                "Average delay for throttled requests: \(String(format: "%.3f", avgDelay)) seconds"
            )
        }

        // With proper rate limiting:
        // - We should have NO 429 errors
        // - Requests should be delayed to stay under 25 req/sec
        // - Total time should be around 2 seconds for 50 requests at 25 req/sec
        #expect(rateLimitErrors == 0, "Rate limiter should prevent ALL 429 errors")
        #expect(successCount == requestsPerSecond, "All requests should eventually succeed")
        #expect(totalDuration > 1.5, "50 requests at 25/sec limit should take ~2 seconds")

        // The effective rate should be close to but not exceed 25 req/sec
        #expect(
            effectiveRequestsPerSecond <= 26,
            "Effective rate should not exceed Stripe's limit (with small tolerance)"
        )
    }

    @Test("Should handle concurrent bursts without 429 errors")
    func testConcurrentBurstWithinLimits() async throws {
        print("\n=== Testing Concurrent Burst Handling ===")

        // Test with exactly 25 concurrent requests (at the limit)
        let concurrentRequests = 25
        var products: [Stripe.Products.Product?] = []

        let startTime = Date()

        // Launch all requests at once
        await withTaskGroup(of: Stripe.Products.Product?.self) { group in
            for i in 1...concurrentRequests {
                group.addTask {
                    @Dependency(Stripe.Products.Products.self) var client
                    do {
                        let product = try await client.client.create(
                            .init(
                                name: "Concurrent Test \(i)",
                                description: "Testing concurrent rate limiting"
                            )
                        )
                        print("Concurrent request \(i): SUCCESS")
                        return product
                    } catch {
                        let errorString = String(describing: error)
                        if errorString.contains("429") {
                            print("Concurrent request \(i): RATE LIMITED")
                        } else {
                            print("Concurrent request \(i): ERROR - \(error)")
                        }
                        return nil
                    }
                }
            }

            for await result in group {
                products.append(result)
            }
        }

        let duration = Date().timeIntervalSince(startTime)
        let successCount = products.compactMap { $0 }.count

        // Cleanup
        @Dependency(Stripe.Products.Products.self) var client
        for product in products.compactMap({ $0 }) {
            _ = try? await client.client.delete(product.id)
        }

        print("\n=== Concurrent Burst Results ===")
        print("Concurrent requests: \(concurrentRequests)")
        print("Successful: \(successCount)")
        print("Failed: \(concurrentRequests - successCount)")
        print("Duration: \(String(format: "%.3f", duration)) seconds")
        print("================================\n")

        // All 25 concurrent requests should succeed (at the limit)
        #expect(
            successCount == concurrentRequests,
            "All 25 concurrent requests should succeed at the limit"
        )
    }

    @Test("Should demonstrate rate limiting behavior over time")
    func testRateLimitingBehaviorOverTime() async throws {
        @Dependency(Stripe.Products.Products.self) var client

        print("\n=== Rate Limiting Behavior Over Time ===")

        // Create a test product
        let product = try await client.client.create(
            .init(
                name: "Timing Test Product",
                description: "Measuring rate limit delays"
            )
        )

        // Make requests and track timing
        let requestCount = 30
        var timings: [TimeInterval] = []
        let startTime = Date()

        for i in 1...requestCount {
            let requestStart = Date()
            _ = try await client.client.retrieve(product.id)
            let requestDuration = Date().timeIntervalSince(requestStart)
            timings.append(requestDuration)

            // Show timing pattern
            if requestDuration > 0.05 {  // Highlight delays > 50ms
                print("Request \(i): \(String(format: "%.3f", requestDuration))s ⚠️ DELAYED")
            } else {
                print("Request \(i): \(String(format: "%.3f", requestDuration))s")
            }
        }

        let totalDuration = Date().timeIntervalSince(startTime)
        let avgRequestTime = timings.reduce(0, +) / Double(timings.count)
        let maxRequestTime = timings.max() ?? 0
        let minRequestTime = timings.min() ?? 0

        // Cleanup
        _ = try? await client.client.delete(product.id)

        print("\n=== Timing Analysis ===")
        print("Total requests: \(requestCount)")
        print("Total duration: \(String(format: "%.3f", totalDuration))s")
        print("Average request time: \(String(format: "%.3f", avgRequestTime))s")
        print("Min request time: \(String(format: "%.3f", minRequestTime))s")
        print("Max request time: \(String(format: "%.3f", maxRequestTime))s")
        print(
            "Effective rate: \(String(format: "%.1f", Double(requestCount) / totalDuration)) req/s"
        )
        print("=======================\n")

        // 30 requests at 25 req/sec should take > 1 second
        #expect(totalDuration > 1.0, "30 requests should take > 1 second at 25 req/sec limit")
    }
}
