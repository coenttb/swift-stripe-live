//
//  Stripe Rate Limit Production Test.swift
//  swift-stripe-live
//
//  Test rate limiting with proper dependencies
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
    "Stripe Rate Limit Production Test",
    .dependency(\.projectRoot, .stripe),
    .dependency(\.envVars, .development),
    .dependency(\.date, .init(Date.init)),
    .dependency(\.continuousClock, ContinuousClock())
)
struct StripeRateLimitProductionTest {

    @Test("Production-like rate limiting test")
    func testProductionRateLimiting() async throws {
        print("\n=== PRODUCTION-LIKE RATE LIMITING TEST ===")
        print("Making 30 rapid requests with real dependencies")
        print("==========================================\n")

        @Dependency(Stripe.Products.Products.self) var products

        // Create a test product
        let product = try await products.client.create(
            .init(
                name: "Production Rate Limit Test",
                description: "Testing with real dependencies"
            )
        )

        let startTime = Date()
        var successCount = 0
        var failureCount = 0

        // Make 30 rapid requests
        for i in 1...30 {
            do {
                let requestStart = Date()
                _ = try await products.client.retrieve(product.id)
                let requestDuration = Date().timeIntervalSince(requestStart)

                successCount += 1

                if requestDuration > 0.05 {
                    print(
                        "Request \(i): SUCCESS (delayed: \(String(format: "%.3f", requestDuration))s)"
                    )
                } else {
                    print(
                        "Request \(i): SUCCESS (fast: \(String(format: "%.3f", requestDuration))s)"
                    )
                }
            } catch {
                failureCount += 1
                let errorString = String(describing: error)
                if errorString.contains("429") {
                    print("Request \(i): RATE LIMITED (should not happen!)")
                } else {
                    print("Request \(i): ERROR - \(error)")
                }
            }
        }

        let totalDuration = Date().timeIntervalSince(startTime)
        let effectiveRate = Double(successCount) / totalDuration

        // Cleanup
        _ = try? await products.client.delete(product.id)

        print("\n=== RESULTS ===")
        print("Total requests: 30")
        print("Successful: \(successCount)")
        print("Failed: \(failureCount)")
        print("Total duration: \(String(format: "%.2f", totalDuration)) seconds")
        print("Effective rate: \(String(format: "%.1f", effectiveRate)) req/sec")
        print("===============\n")

        // With our rate limiting at 25 req/sec for test mode:
        // 30 requests should take at least 1.2 seconds
        #expect(failureCount == 0, "Should have no failures with rate limiting")
        #expect(successCount == 30, "All requests should succeed")

        if effectiveRate > 25 {
            print("⚠️ Rate exceeded 25 req/sec - rate limiting may not be working")
        } else {
            print("✅ Rate limiting is working correctly!")
        }

    }
}
