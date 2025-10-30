import Stripe_Billing_Types
//
//  File.swift
//  swift-stripe
//
//  Created by Coen ten Thije Boonkkamp on 09/01/2025.
//
import Stripe_Live_Shared

extension Stripe.Billing.Client {
  public static func live(
    makeRequest: @escaping @Sendable (_ route: Stripe.Billing.API) throws -> URLRequest
  ) -> Self {
    @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

    return Self(
      customer_Portal_Session: .live { try makeRequest(.customer_Portal_Session($0)) },
      subscriptions: .live { try makeRequest(.subscriptions($0)) },
      subscriptionSchedule: .live { try makeRequest(.subscriptionSchedule($0)) }
    )
  }
}

extension Stripe.Billing {
  public typealias Authenticated = Stripe_Live_Shared.Authenticated<
    Stripe.Billing.API,
    Stripe.Billing.API.Router,
    Stripe.Billing.Client
  >
}

extension Stripe.Billing: @retroactive DependencyKey {
  public static var liveValue: Stripe.Billing.Authenticated {
    try! Stripe.Billing.Authenticated { .live(makeRequest: $0) }
  }
  public static let testValue: Stripe.Billing.Authenticated = liveValue
}

extension Stripe.Billing.API.Router: @retroactive DependencyKey {
  public static let liveValue: Self = .init()
  public static let testValue: Self = .init()
}
