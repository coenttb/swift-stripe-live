import Stripe_Billing_Types
//
//  File.swift
//  swift-stripe-live
//
//  Created by Coen ten Thije Boonkkamp on 05/01/2025.
//
import Stripe_Live_Shared

extension Stripe.Billing.Subscriptions.Client {
    public static func live(
        makeRequest:
            @escaping @Sendable (_ route: Stripe.Billing.Subscriptions.API) throws -> URLRequest
    ) -> Self {

        @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

        return Self(
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Stripe.Billing.Subscription.self
                )
            },

            update: { id, request in
                try await handleRequest(
                    for: makeRequest(.update(id: id, request: request)),
                    decodingTo: Stripe.Billing.Subscription.self
                )
            },

            retrieve: { id in
                try await handleRequest(
                    for: makeRequest(.retrieve(id: id)),
                    decodingTo: Stripe.Billing.Subscription.self
                )
            },

            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(request: request)),
                    decodingTo: Stripe.Billing.Subscriptions.List.Response.self
                )
            },

            cancel: { id, request in
                try await handleRequest(
                    for: makeRequest(.cancel(id: id, request: request)),
                    decodingTo: Stripe.Billing.Subscription.self
                )
            }
        )
    }
}

extension Stripe.Billing.Subscriptions {
    public typealias Authenticated = Stripe_Live_Shared.Authenticated<
        Stripe.Billing.Subscriptions.API,
        Stripe.Billing.Subscriptions.API.Router,
        Stripe.Billing.Subscriptions.Client
    >
}

extension Stripe.Billing.Subscriptions: @retroactive DependencyKey {
    public static var liveValue: Stripe.Billing.Subscriptions.Authenticated {
        try! Stripe.Billing.Subscriptions.Authenticated { .live(makeRequest: $0) }
    }
    public static let testValue: Stripe.Billing.Subscriptions.Authenticated = liveValue
}

extension Stripe.Billing.Subscriptions.API.Router: @retroactive DependencyKey {
    public static let liveValue: Self = .init()
    public static let testValue: Self = .init()
}
