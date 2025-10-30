//
//  Stripe Rate Limit Extreme Tests.swift
//  swift-stripe-live
//
//  Extreme tests to trigger actual 429 errors
//

import Dependencies
import DependenciesTestSupport
import EnvironmentVariables
import Foundation
import Stripe_Live_Shared
import Stripe_Products_Live
import Testing

@Suite(
  "Stripe Rate Limit Extreme Tests",
  .dependency(\.projectRoot, .stripe),
  .dependency(\.envVars, .development),
  .dependency(\.date, .init(Date.init)),
  .dependency(\.continuousClock, ContinuousClock())
)
struct StripeRateLimitExtremeTests {
  @Dependency(\.date) var date
  @Dependency(\.envVars) var envVars

  @Test("Extreme concurrent load to trigger 429s")
  func testExtremeConcurrentLoad() async throws {
    print("\n=== EXTREME CONCURRENT LOAD TEST ===")
    print("Attempting 100 concurrent requests")
    print("This should definitely exceed 25 req/sec")
    print("=====================================\n")

    let apiKey = envVars.stripe.secretKey.rawValue
    let baseURL = "https://api.stripe.com/v1"

    // First create a product to query
    @Dependency(Stripe.Products.Products.self) var client
    let product = try await client.client.create(
      .init(name: "Extreme Test Product", description: "For extreme testing")
    )

    let url = URL(string: "\(baseURL)/products/\(product.id)")!

    // Launch 100 concurrent requests
    await withTaskGroup(of: (Int, Int).self) { group in
      for i in 1...100 {
        group.addTask {
          var request = URLRequest(url: url)
          request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
          request.httpMethod = "GET"

          do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
              return (i, httpResponse.statusCode)
            }
          } catch {
            // Network error
            return (i, -1)
          }
          return (i, 0)
        }
      }

      var results: [(request: Int, status: Int)] = []
      for await result in group {
        results.append((request: result.0, status: result.1))
      }

      // Count results
      let successful = results.filter { $0.status == 200 }.count
      let rateLimited = results.filter { $0.status == 429 }.count
      let errors = results.filter { $0.status < 0 }.count
      let other = results.filter { $0.status != 200 && $0.status != 429 && $0.status >= 0 }.count

      print("\n=== EXTREME LOAD RESULTS ===")
      print("Total requests: 100")
      print("Successful (200): \(successful)")
      print("Rate limited (429): \(rateLimited)")
      print("Network errors: \(errors)")
      print("Other status codes: \(other)")
      print("============================\n")

      if rateLimited > 0 {
        print("✅ Successfully triggered \(rateLimited) rate limit errors!")
        print("This confirms Stripe's rate limiting is working.")
      } else {
        print("⚠️ No 429 errors even with 100 concurrent requests.")
        print("Stripe may have higher limits or tolerance than documented.")
      }
    }

    // Cleanup
    _ = try? await client.client.delete(product.id)
  }

  @Test("Test our rate limiter prevents 429s under extreme load")
  func testOurRateLimiterPrevents429s() async throws {
    print("\n=== TESTING OUR RATE LIMITER UNDER EXTREME LOAD ===")
    print("100 concurrent requests through our rate limiter")
    print("====================================================\n")

    let startTime = date()
    var results: [(index: Int, success: Bool)] = []

    await withTaskGroup(of: (Int, Bool).self) { group in
      for i in 1...100 {
        group.addTask {
          @Dependency(Stripe.Products.Products.self) var client
          do {
            // Just list products (simple, fast operation)
            _ = try await client.client.list(.init(limit: 1))
            return (i, true)
          } catch {
            let errorString = String(describing: error)
            if errorString.contains("429") {
              print("Request \(i): RATE LIMITED (should not happen!)")
            }
            return (i, false)
          }
        }
      }

      for await result in group {
        results.append((index: result.0, success: result.1))
        if result.0 % 10 == 0 {
          print("Completed \(result.0) requests...")
        }
      }
    }

    let duration = date().timeIntervalSince(startTime)
    let successful = results.filter { $0.success }.count
    let failed = results.filter { !$0.success }.count

    print("\n=== OUR RATE LIMITER RESULTS ===")
    print("Total requests: 100")
    print("Successful: \(successful)")
    print("Failed: \(failed)")
    print("Total duration: \(String(format: "%.2f", duration)) seconds")
    print("Effective rate: \(String(format: "%.1f", Double(successful) / duration)) req/sec")
    print("=================================\n")

    // With proper rate limiting:
    // - ALL requests should succeed (no 429s)
    // - Duration should be ~4 seconds (100 requests at 25/sec)
    #expect(successful == 100, "All 100 requests should succeed with rate limiting")
    #expect(duration > 3.5, "100 requests at 25/sec should take ~4 seconds")

    print("✅ Our rate limiter successfully handled extreme load!")
    print("No 429 errors despite 100 concurrent requests.")
  }
}
