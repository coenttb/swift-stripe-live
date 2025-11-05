//
//  File.swift
//  coenttb-stripe
//
//  Created by Coen ten Thije Boonkkamp on 04/01/2025.
//
import Stripe_Live_Shared
import Stripe_Payment_Intents_Types

extension Stripe.PaymentIntents.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Stripe.PaymentIntents.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Stripe.self) var handleRequest
        return Self(
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Stripe.PaymentIntents.PaymentIntent.self
                )
            },

            update: { id, request in
                try await handleRequest(
                    for: makeRequest(.update(id: id, request: request)),
                    decodingTo: Stripe.PaymentIntents.PaymentIntent.self
                )
            },

            retrieve: { id in
                try await handleRequest(
                    for: makeRequest(.retrieve(id: id)),
                    decodingTo: Stripe.PaymentIntents.PaymentIntent.self
                )
            },

            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(request: request)),
                    decodingTo: Stripe.PaymentIntents.List.Response.self
                )
            },

            cancel: { id, request in
                try await handleRequest(
                    for: makeRequest(.cancel(id: id, request: request)),
                    decodingTo: Stripe.PaymentIntents.PaymentIntent.self
                )
            },

            capture: { id, request in
                try await handleRequest(
                    for: makeRequest(.capture(id: id, request: request)),
                    decodingTo: Stripe.PaymentIntents.PaymentIntent.self
                )
            },

            confirm: { id, request in
                try await handleRequest(
                    for: makeRequest(.confirm(id: id, request: request)),
                    decodingTo: Stripe.PaymentIntents.PaymentIntent.self
                )
            },

            incrementAuthorization: { id, request in
                try await handleRequest(
                    for: makeRequest(.incrementAuthorization(id: id, request: request)),
                    decodingTo: Stripe.PaymentIntents.PaymentIntent.self
                )
            },

            applyCustomerBalance: { id in
                try await handleRequest(
                    for: makeRequest(.applyCustomerBalance(id: id)),
                    decodingTo: Stripe.PaymentIntents.PaymentIntent.self
                )
            },

            search: { request in
                try await handleRequest(
                    for: makeRequest(.search(request: request)),
                    decodingTo: Stripe.PaymentIntents.Search.Response.self
                )
            },

            verifyMicrodeposits: { id, request in
                try await handleRequest(
                    for: makeRequest(.verifyMicrodeposits(id: id, request: request)),
                    decodingTo: Stripe.PaymentIntents.PaymentIntent.self
                )
            }
        )
    }
}

extension Stripe.PaymentIntents {
    public typealias Authenticated = Stripe_Live_Shared.Authenticated<
        Stripe.PaymentIntents.API,
        Stripe.PaymentIntents.API.Router,
        Stripe.PaymentIntents.Client
    >
}

extension Stripe.PaymentIntents: @retroactive DependencyKey {
    public static var liveValue: Stripe.PaymentIntents.Authenticated {
        try! Stripe.PaymentIntents.Authenticated { .live(makeRequest: $0) }
    }
    public static let testValue: Stripe.PaymentIntents.Authenticated = liveValue
}

extension Stripe.PaymentIntents.API.Router: @retroactive DependencyKey {
    public static let liveValue: Self = .init()
    public static let testValue: Self = .init()
}
