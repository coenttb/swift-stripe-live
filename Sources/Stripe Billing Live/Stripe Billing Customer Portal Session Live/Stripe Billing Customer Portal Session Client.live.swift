import Dependencies
import Stripe_Billing_Types
//
//  Stripe Billing Customer Portal Session Client.live.swift
//  swift-stripe-live
//
//  Created on 14/01/2025.
//
import Stripe_Live_Shared
import Stripe_Types_Models

extension Stripe.Billing.Customer.Portal.Session.Client {
  public static func live(
    makeRequest:
      @escaping @Sendable (_ route: Stripe.Billing.Customer.Portal.Session.API) throws -> URLRequest
  ) -> Self {
    @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

    return Self(
      create: { request in
        try await handleRequest(
          for: makeRequest(.create(request: request)),
          decodingTo: Stripe.Billing.Customer.Portal.Session.self
        )
      }
    )
  }
}

extension Stripe.Billing.Customer.Portal.Session {
  public typealias Authenticated = Stripe_Live_Shared.Authenticated<
    Stripe.Billing.Customer.Portal.Session.API,
    Stripe.Billing.Customer.Portal.Session.API.Router,
    Stripe.Billing.Customer.Portal.Session.Client
  >
}

extension Stripe.Billing.Customer.Portal.Session: @retroactive DependencyKey {
  public static var liveValue: Stripe.Billing.Customer.Portal.Session.Authenticated {
    try! Stripe.Billing.Customer.Portal.Session.Authenticated { .live(makeRequest: $0) }
  }
  public static let testValue: Stripe.Billing.Customer.Portal.Session.Authenticated = liveValue
}

extension Stripe.Billing.Customer.Portal.Session.API.Router: @retroactive DependencyKey {
  public static let liveValue: Self = .init()
  public static let testValue: Self = .init()
}
