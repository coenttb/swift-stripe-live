import Dependencies
import Stripe_Customers_Types
//
//  Stripe Customers Cash Balance Transactions Types Client.live.swift
//  swift-stripe-live
//
//  Created on 14/01/2025.
//
import Stripe_Live_Shared
import Stripe_Types_Models

extension Stripe.Customers.CashBalanceTransactions.Client {
  public static func live(
    makeRequest:
      @escaping @Sendable (_ route: Stripe.Customers.CashBalanceTransactions.API) throws ->
      URLRequest
  ) -> Self {
    @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

    return .init(
      retrieve: { customerId, transactionId in
        try await handleRequest(
          for: makeRequest(.retrieve(customerId: customerId, transactionId: transactionId)),
          decodingTo: CashBalanceTransaction.self
        )
      },
      list: { customerId, request in
        try await handleRequest(
          for: makeRequest(.list(customerId: customerId, request: request)),
          decodingTo: Stripe.Customers.CashBalanceTransactions.List.Response.self
        )
      }
    )
  }
}

extension Stripe.Customers.CashBalanceTransactions {
  public typealias Authenticated = Stripe_Live_Shared.Authenticated<
    Stripe.Customers.CashBalanceTransactions.API,
    Stripe.Customers.CashBalanceTransactions.API.Router,
    Stripe.Customers.CashBalanceTransactions.Client
  >
}

extension Stripe.Customers.CashBalanceTransactions: @retroactive DependencyKey {
  public static var liveValue: Stripe.Customers.CashBalanceTransactions.Authenticated {
    try! Stripe.Customers.CashBalanceTransactions.Authenticated { .live(makeRequest: $0) }
  }
  public static let testValue: Stripe.Customers.CashBalanceTransactions.Authenticated = liveValue
}

extension Stripe.Customers.CashBalanceTransactions.API.Router: @retroactive DependencyKey {
  public static let liveValue: Self = .init()
  public static let testValue: Self = .init()
}
