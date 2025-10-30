import Dependencies
import Stripe_Billing_Types
//
//  Stripe Billing Tax IDs Client.live.swift
//  swift-stripe-live
//
//  Created on 14/01/2025.
//
import Stripe_Live_Shared
import Stripe_Types_Models

extension Stripe.Billing.TaxIDs.Client {
  public static func live(
    makeRequest: @escaping @Sendable (_ route: Stripe.Billing.TaxIDs.API) throws -> URLRequest
  ) -> Self {
    @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

    return Self(
      create: { customerId, request in
        try await handleRequest(
          for: makeRequest(.create(customerId: customerId, request: request)),
          decodingTo: Stripe.Billing.TaxIDs.TaxID.self
        )
      },

      retrieve: { customerId, id in
        try await handleRequest(
          for: makeRequest(.retrieve(customerId: customerId, id: id)),
          decodingTo: Stripe.Billing.TaxIDs.TaxID.self
        )
      },

      delete: { customerId, id in
        try await handleRequest(
          for: makeRequest(.delete(customerId: customerId, id: id)),
          decodingTo: DeletedObject<Stripe.Customers.Customer>.self
        )
      },

      list: { customerId, request in
        try await handleRequest(
          for: makeRequest(.list(customerId: customerId, request: request)),
          decodingTo: Stripe.Billing.TaxIDs.List.Response.self
        )
      }
    )
  }
}

extension Stripe.Billing.TaxIDs {
  public typealias Authenticated = Stripe_Live_Shared.Authenticated<
    Stripe.Billing.TaxIDs.API,
    Stripe.Billing.TaxIDs.API.Router,
    Stripe.Billing.TaxIDs.Client
  >
}

extension Stripe.Billing.TaxIDs: @retroactive DependencyKey {
  public static var liveValue: Stripe.Billing.TaxIDs.Authenticated {
    try! Stripe.Billing.TaxIDs.Authenticated { .live(makeRequest: $0) }
  }
  public static let testValue: Stripe.Billing.TaxIDs.Authenticated = liveValue
}

extension Stripe.Billing.TaxIDs.API.Router: @retroactive DependencyKey {
  public static let liveValue: Self = .init()
  public static let testValue: Self = .init()
}
