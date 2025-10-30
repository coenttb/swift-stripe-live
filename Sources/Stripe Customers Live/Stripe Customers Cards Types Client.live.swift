import Dependencies
import Stripe_Customers_Types
//
//  Stripe Customers Cards Types Client.live.swift
//  swift-stripe-live
//
//  Created on 14/01/2025.
//
import Stripe_Live_Shared
import Stripe_Types_Models

extension Stripe.Customers.Cards.Client {
  public static func live(
    makeRequest: @escaping @Sendable (_ route: Stripe.Customers.Cards.API) throws -> URLRequest
  ) -> Self {
    @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

    return .init(
      create: { customerId, request in
        try await handleRequest(
          for: makeRequest(.create(customerId: customerId, request: request)),
          decodingTo: Card.self
        )
      },
      retrieve: { customerId, cardId in
        try await handleRequest(
          for: makeRequest(.retrieve(customerId: customerId, cardId: cardId)),
          decodingTo: Card.self
        )
      },
      update: { customerId, cardId, request in
        try await handleRequest(
          for: makeRequest(.update(customerId: customerId, cardId: cardId, request: request)),
          decodingTo: Card.self
        )
      },
      list: { customerId, request in
        try await handleRequest(
          for: makeRequest(.list(customerId: customerId, request: request)),
          decodingTo: Stripe.Customers.Cards.List.Response.self
        )
      },
      delete: { customerId, cardId in
        try await handleRequest(
          for: makeRequest(.delete(customerId: customerId, cardId: cardId)),
          decodingTo: DeletedObject<Card>.self
        )
      }
    )
  }
}

extension Stripe.Customers.Cards {
  public typealias Authenticated = Stripe_Live_Shared.Authenticated<
    Stripe.Customers.Cards.API,
    Stripe.Customers.Cards.API.Router,
    Stripe.Customers.Cards.Client
  >
}

extension Stripe.Customers.Cards: @retroactive DependencyKey {
  public static var liveValue: Stripe.Customers.Cards.Authenticated {
    try! Stripe.Customers.Cards.Authenticated { .live(makeRequest: $0) }
  }
  public static let testValue: Stripe.Customers.Cards.Authenticated = liveValue
}

extension Stripe.Customers.Cards.API.Router: @retroactive DependencyKey {
  public static let liveValue: Self = .init()
  public static let testValue: Self = .init()
}
