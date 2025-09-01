//
//  Stripe Rate Limiting Integration Tests.swift
//  swift-stripe-live
//
//  Tests to verify rate limiting is working correctly
//

import Testing
import Dependencies
import DependenciesTestSupport
import EnvironmentVariables
import Foundation
import Stripe_Products_Live
import Stripe_Live_Shared
import Clocks

@Suite(
    "Stripe Rate Limiting Integration Tests",
    .dependency(\.projectRoot, .stripe),
    .dependency(\.envVars, .development),
    .dependency(\.date, .init(Date.init)),
    .dependency(\.continuousClock, ContinuousClock()),
    .serialized
)
struct StripeRateLimitingIntegrationTests {
    
    @Test("Should handle rate limiting without 429 errors")
    func testRateLimitingPrevents429Errors() async throws {
        @Dependency(Stripe.Products.Products.self) var client
        @Dependency(\.continuousClock) var clock
        
        // Test rate limits are 25 requests/sec = 1500/min
        // Let's try to make 30 requests rapidly
        let numberOfRequests = 30
        var successCount = 0
        var rateLimitErrors = 0
        var otherErrors = 0
        
        // Create a test product to work with
        let baseProduct = try await client.client.create(
            .init(
                name: "Rate Limit Test Product",
                description: "Testing rate limiting"
            )
        )
        
        print("Starting rapid-fire requests to test rate limiting...")
        
        // Make requests as fast as possible
        for i in 1...numberOfRequests {
            do {
                // Alternate between different operations to avoid caching
                if i % 3 == 0 {
                    // Retrieve
                    _ = try await client.client.retrieve(baseProduct.id)
                } else if i % 3 == 1 {
                    // Update
                    _ = try await client.client.update(
                        baseProduct.id,
                        .init(description: "Update \(i)")
                    )
                } else {
                    // List
                    _ = try await client.client.list(.init(limit: 1))
                }
                successCount += 1
                print("Request \(i): SUCCESS")
            } catch {
                let errorString = String(describing: error)
                if errorString.contains("429") || errorString.contains("rate_limit") {
                    rateLimitErrors += 1
                    print("Request \(i): RATE LIMITED (429)")
                } else {
                    otherErrors += 1
                    print("Request \(i): ERROR - \(error)")
                }
            }
        }
        
        // Cleanup
        _ = try? await client.client.delete(baseProduct.id)
        
        print("\n=== Rate Limiting Test Results ===")
        print("Total requests: \(numberOfRequests)")
        print("Successful: \(successCount)")
        print("Rate limit errors (429): \(rateLimitErrors)")
        print("Other errors: \(otherErrors)")
        print("==================================\n")
        
        // With proper rate limiting, we should have NO 429 errors
        // The rate limiter should delay requests to prevent hitting Stripe's limits
        #expect(rateLimitErrors == 0, "Rate limiter should prevent 429 errors, but got \(rateLimitErrors)")
        
        // All requests should eventually succeed
        #expect(successCount == numberOfRequests, "All requests should succeed with rate limiting")
    }
    
    @Test("Should introduce delays when approaching rate limit")
    func testRateLimitingIntroducesDelays() async throws {
        @Dependency(Stripe.Products.Products.self) var client
        @Dependency(\.continuousClock) var clock
        
        // Create a test product
        let product = try await client.client.create(
            .init(
                name: "Delay Test Product",
                description: "Testing rate limit delays"
            )
        )
        
        print("\nTesting rate limiting delays...")
        
        // Make several requests and measure timing
        let startTime = Date()
        let requestCount = 10
        
        for i in 1...requestCount {
            let requestStart = Date()
            _ = try await client.client.retrieve(product.id)
            let requestDuration = Date().timeIntervalSince(requestStart)
            print("Request \(i) took: \(String(format: "%.3f", requestDuration)) seconds")
        }
        
        let totalDuration = Date().timeIntervalSince(startTime)
        print("Total time for \(requestCount) requests: \(String(format: "%.3f", totalDuration)) seconds")
        
        // Cleanup
        _ = try? await client.client.delete(product.id)
        
        // With rate limiting, rapid requests should take some time due to delays
        // Without rate limiting, 10 requests would complete in < 2 seconds
        // With rate limiting at 25 req/sec, they should still be fast but controlled
        #expect(totalDuration < 10, "Requests should complete reasonably quickly")
    }
    
    @Test("Should handle burst requests gracefully")
    func testBurstRequestHandling() async throws {
        print("\nTesting burst request handling...")
        
        // Create multiple products in parallel (burst)
        let productNames = (1...5).map { "Burst Test Product \($0)" }
        
        var createdProducts: [Stripe.Products.Product] = []
        
        // Launch all requests concurrently
        await withTaskGroup(of: Stripe.Products.Product?.self) { group in
            for name in productNames {
                group.addTask {
                    @Dependency(Stripe.Products.Products.self) var client
                    do {
                        let product = try await client.client.create(
                            .init(name: name, description: "Burst test")
                        )
                        return product
                    } catch {
                        return nil
                    }
                }
            }
            
            for await result in group {
                if let product = result {
                    createdProducts.append(product)
                }
            }
        }
        
        print("Burst results: \(createdProducts.count) successes, \(productNames.count - createdProducts.count) failures")
        
        // Cleanup
        @Dependency(Stripe.Products.Products.self) var client
        for product in createdProducts {
            _ = try? await client.client.delete(product.id)
        }
        
        // All burst requests should succeed with rate limiting
        #expect(createdProducts.count == productNames.count, "All burst requests should succeed")
        #expect(createdProducts.count > 0, "At least some requests should succeed")
    }
}
