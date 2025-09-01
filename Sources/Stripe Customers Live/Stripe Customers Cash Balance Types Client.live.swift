//
//  Stripe Customers Cash Balance Types Client.live.swift
//  swift-stripe-live
//
//  Created on 14/01/2025.
//
import Stripe_Live_Shared
import Stripe_Customers_Types
import Stripe_Types_Models
import Dependencies

extension Stripe.Customers.CashBalance.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Stripe.Customers.CashBalance.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Stripe.self) var handleRequest
        
        return .init(
            retrieve: { customerId in
                try await handleRequest(
                    for: makeRequest(.retrieve(customerId: customerId)),
                    decodingTo: Stripe_Types_Models.CashBalance.self
                )
            },
            update: { customerId, request in
                try await handleRequest(
                    for: makeRequest(.update(customerId: customerId, request: request)),
                    decodingTo: Stripe_Types_Models.CashBalance.self
                )
            }
        )
    }
}

extension Stripe.Customers.CashBalance {
    public typealias Authenticated = Stripe_Live_Shared.Authenticated<
        Stripe.Customers.CashBalance.API,
        Stripe.Customers.CashBalance.API.Router,
        Stripe.Customers.CashBalance.Client
    >
}

extension Stripe.Customers.CashBalance: @retroactive DependencyKey {
    public static var liveValue: Stripe.Customers.CashBalance.Authenticated {
        try! Stripe.Customers.CashBalance.Authenticated { .live(makeRequest: $0) }
    }
    public static let testValue: Stripe.Customers.CashBalance.Authenticated = liveValue
}

extension Stripe.Customers.CashBalance.API.Router: @retroactive DependencyKey {
    public static let liveValue: Self = .init()
    public static let testValue: Self = .init()
}