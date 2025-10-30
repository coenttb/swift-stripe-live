import Stripe_Customers_Types
//
//  Customers Client.live.swift
//  swift-stripe-live
//
//  Created by Coen ten Thije Boonkkamp on 05/01/2025.
//
import Stripe_Live_Shared

extension Stripe.Customers.Client {
  public static func live(
    makeRequest: @escaping @Sendable (_ route: Stripe.Customers.API) throws -> URLRequest
  ) -> Self {
    @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

    return Self(
      create: { request in
        try await handleRequest(
          for: makeRequest(.create(request: request)),
          decodingTo: Stripe.Customers.Customer.self
        )
      },

      update: { id, request in
        try await handleRequest(
          for: makeRequest(.update(id: id, request: request)),
          decodingTo: Stripe.Customers.Customer.self
        )
      },

      retrieve: { id in
        try await handleRequest(
          for: makeRequest(.retrieve(id: id)),
          decodingTo: Stripe.Customers.Customer.self
        )
      },

      list: { request in
        try await handleRequest(
          for: makeRequest(.list(request: request)),
          decodingTo: Stripe.Customers.List.Response.self
        )
      },

      delete: { id in
        try await handleRequest(
          for: makeRequest(.delete(id: id)),
          decodingTo: DeletedObject.self
        )
      },

      search: { request in
        try await handleRequest(
          for: makeRequest(.search(request: request)),
          decodingTo: Stripe.Customers.Search.Response.self
        )
      },
      bankAccounts: .live(makeRequest: { try makeRequest(.bankAccounts($0)) }),
      cards: .live(makeRequest: { try makeRequest(.cards($0)) }),
      cashBalance: .live(makeRequest: { try makeRequest(.cashBalance($0)) }),
      cashBalanceTransactions: .live(makeRequest: { try makeRequest(.cashBalanceTransactions($0)) })
    )
  }
}

extension Stripe.Customers {
  public typealias Authenticated = Stripe_Live_Shared.Authenticated<
    Stripe.Customers.API,
    Stripe.Customers.API.Router,
    Stripe.Customers.Client
  >
}

extension Stripe.Customers: @retroactive DependencyKey {
  public static var liveValue: Stripe.Customers.Authenticated {
    try! Stripe.Customers.Authenticated { .live(makeRequest: $0) }
  }
  public static let testValue: Stripe.Customers.Authenticated = liveValue
}

extension Stripe.Customers.API.Router: @retroactive DependencyKey {
  public static let liveValue: Self = .init()
  public static let testValue: Self = .init()
}
