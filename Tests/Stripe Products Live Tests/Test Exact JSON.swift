//
//  Test Exact JSON.swift
//  swift-stripe-live
//

import Foundation
import Stripe_Products_Types
import Testing

@Test("Test Exact JSON From Error")
func testExactJSONFromError() throws {
  // This is the exact JSON from the error message
  let json = """
    {
      "id": "prod_SrJ2WUHjffo8tX",
      "object": "product",
      "active": true,
      "attributes": [],
      "created": 1755075181,
      "default_price": null,
      "description": "Test product creation",
      "images": [],
      "livemode": false,
      "marketing_features": [],
      "metadata": {
        "category": "test_category"
      },
      "name": "Test Product",
      "package_dimensions": null,
      "shippable": true,
      "statement_descriptor": null,
      "tax_code": null,
      "type": "service",
      "unit_label": null,
      "updated": 1755075181,
      "url": null
    }
    """

  let decoder = JSONDecoder()
  decoder.dateDecodingStrategy = .secondsSince1970

  let data = json.data(using: .utf8)!

  do {
    let product = try decoder.decode(Stripe.Products.Product.self, from: data)
    print("Successfully decoded product: \(product.id)")
    #expect(product.id == "prod_SrJ2WUHjffo8tX")
    #expect(product.name == "Test Product")
    #expect(product.shippable == true)
    #expect(product.type == .service)
  } catch {
    print("Decoding error: \(error)")
    throw error
  }
}
