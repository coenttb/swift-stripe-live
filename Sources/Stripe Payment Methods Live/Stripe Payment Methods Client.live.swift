import Dependencies
//
//  Stripe Payment Methods Client.live.swift
//  swift-stripe-live
//
//  Created on 14/01/2025.
//
import Stripe_Live_Shared
import Stripe_Payment_Methods_Types
import Stripe_Types_Models

extension Stripe.PaymentMethods.Client {
  public static func live(
    makeRequest: @escaping @Sendable (_ route: Stripe.PaymentMethods.API) throws -> URLRequest
  ) -> Self {
    @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

    return .init(
      paymentMethods: .live(makeRequest: { try makeRequest(.paymentMethods($0)) }),
      paymentMethodConfigurations: .live(makeRequest: {
        try makeRequest(.paymentMethodConfigurations($0))
      }),
      paymentMethodDomains: .live(makeRequest: { try makeRequest(.paymentMethodDomains($0)) }),
      sources: .live(makeRequest: { try makeRequest(.sources($0)) })
    )
  }
}

extension Stripe.PaymentMethods {
  public typealias Authenticated = Stripe_Live_Shared.Authenticated<
    Stripe.PaymentMethods.API,
    Stripe.PaymentMethods.API.Router,
    Stripe.PaymentMethods.Client
  >
}

extension Stripe.PaymentMethods: @retroactive DependencyKey {
  public static var liveValue: Stripe.PaymentMethods.Authenticated {
    try! Stripe.PaymentMethods.Authenticated { .live(makeRequest: $0) }
  }
  public static let testValue: Stripe.PaymentMethods.Authenticated = liveValue
}

extension Stripe.PaymentMethods.API.Router: @retroactive DependencyKey {
  public static let liveValue: Self = .init()
  public static let testValue: Self = .init()
}
