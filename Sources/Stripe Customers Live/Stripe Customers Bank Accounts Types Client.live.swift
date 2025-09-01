//
//  Customers Client.live.swift
//  swift-stripe-live
//
//  Created by Coen ten Thije Boonkkamp on 05/01/2025.
//
import Stripe_Live_Shared
import Stripe_Customers_Types

extension Stripe.Customers.BankAccounts.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Stripe.Customers.BankAccounts.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Stripe.self) var handleRequest
        
        return .init(
            create: { customerId, request in
                try await handleRequest(
                    for: makeRequest(.create(customerId: customerId, request: request)),
                    decodingTo: BankAccount.self
                )
            },
            retrieve: { customerId, bankAccountId in
                try await handleRequest(
                    for: makeRequest(.retrieve(customerId: customerId, bankAccountId: bankAccountId)),
                    decodingTo: BankAccount.self
                )
            },
            update: { customerId, bankAccountId, request in
                try await handleRequest(
                    for: makeRequest(.update(customerId: customerId, bankAccountId: bankAccountId, request: request)),
                    decodingTo: BankAccount.self
                )
            },
            list: { customerId, request in
                try await handleRequest(
                    for: makeRequest(.list(customerId: customerId, request: request)),
                    decodingTo: Stripe.Customers.BankAccounts.List.Response.self
                )
            },
            delete: { customerId, bankAccountId in
                try await handleRequest(
                    for: makeRequest(.delete(customerId: customerId, bankAccountId: bankAccountId)),
                    decodingTo: DeletedObject<BankAccount>.self
                )
            },
            verify: { customerId, bankAccountId, request in
                try await handleRequest(
                    for: makeRequest(.verify(customerId: customerId, bankAccountId: bankAccountId, request: request)),
                    decodingTo: BankAccount.self
                )
            }
        )
    }
}

extension Stripe.Customers.BankAccounts {
    public typealias Authenticated = Stripe_Live_Shared.Authenticated<
        Stripe.Customers.BankAccounts.API,
        Stripe.Customers.BankAccounts.API.Router,
        Stripe.Customers.BankAccounts.Client
    >
}

extension Stripe.Customers.BankAccounts: @retroactive DependencyKey {
    public static var liveValue: Stripe.Customers.BankAccounts.Authenticated {
        try! Stripe.Customers.BankAccounts.Authenticated { .live(makeRequest: $0) }
    }
    public static let testValue: Stripe.Customers.BankAccounts.Authenticated = liveValue
}

extension Stripe.Customers.BankAccounts.API.Router: @retroactive DependencyKey {
    public static let liveValue: Self = .init()
    public static let testValue: Self = .init()
}


