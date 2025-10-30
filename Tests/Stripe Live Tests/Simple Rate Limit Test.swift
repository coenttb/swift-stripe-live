//
//  Simple Rate Limit Test.swift
//  swift-stripe-live
//
//  Simple test to verify rate limiting works
//

import Dependencies
import DependenciesTestSupport
import EnvironmentVariables
import Foundation
import Stripe_Live_Shared
import Stripe_Products_Live
import Testing

@Suite(
  "Simple Rate Limit Test",
  .dependency(\.projectRoot, .stripe),
  .dependency(\.envVars, .development),
  .dependency(\.date, .init(Date.init)),
  .dependency(\.continuousClock, ContinuousClock())
)
struct SimpleRateLimitTest {

  @Test("Rate limiter prevents 429 errors")
  func testRateLimiterPrevents429s() async throws {
    print("\n=== TESTING RATE LIMITER ===")
    print("Making 50 rapid requests through our rate limiter")
    print("============================\n")

    @Dependency(Stripe.Products.Products.self) var client

    // Create a test product first
    let product = try await client.client.create(
      .init(name: "Rate Limit Test", description: "Testing rate limiting")
    )

    var successCount = 0
    var failureCount = 0

    // Make 50 rapid requests
    for i in 1...50 {
      do {
        _ = try await client.client.retrieve(product.id)
        successCount += 1
        if i % 10 == 0 {
          print("✓ Request \(i): SUCCESS")
        }
      } catch {
        failureCount += 1
        print("✗ Request \(i): FAILED - \(error)")
      }
    }

    // Cleanup
    _ = try? await client.client.delete(product.id)

    print("\n=== RESULTS ===")
    print("Total requests: 50")
    print("Successful: \(successCount)")
    print("Failed: \(failureCount)")
    print("===============\n")

    // With our rate limiting, all requests should succeed
    #expect(successCount == 50, "All requests should succeed with rate limiting")
    #expect(failureCount == 0, "Should have no failures")

    if failureCount == 0 {
      print("✅ Rate limiter successfully prevented all 429 errors!")
    } else {
      print("⚠️ Some requests failed despite rate limiting")
    }
  }
}
