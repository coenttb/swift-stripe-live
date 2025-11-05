//
//  Test Handler Decode.swift
//  swift-stripe-live
//

import Dependencies
import Foundation
import ServerFoundation
import Stripe_Products_Live
import Testing

@Test("Test Handler Decode Product")
func testHandlerDecodeProduct() async throws {
    let json = """
        {
          "id": "prod_Test",
          "object": "product",
          "active": true,
          "attributes": [],
          "created": 1755074202,
          "default_price": null,
          "description": "Test product",
          "images": [],
          "livemode": false,
          "marketing_features": [],
          "metadata": {},
          "name": "Test Product",
          "package_dimensions": null,
          "shippable": true,
          "statement_descriptor": null,
          "tax_code": null,
          "type": "service",
          "unit_label": null,
          "updated": 1755074202,
          "url": null
        }
        """

    // Create a mock handler that returns our JSON
    @Dependency(URLRequest.Handler.Stripe.self) var handler

    // Test direct decode first
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    let data = json.data(using: .utf8)!

    do {
        let product = try decoder.decode(Stripe.Products.Product.self, from: data)
        print("Direct decode succeeded: \(product.id)")
    } catch {
        print("Direct decode failed: \(error)")
        throw error
    }
}
