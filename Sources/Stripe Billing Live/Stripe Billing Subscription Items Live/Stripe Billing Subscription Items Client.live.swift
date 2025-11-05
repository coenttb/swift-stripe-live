import Dependencies
import Stripe_Billing_Types
//
//  File.swift
//  swift-stripe-live
//
//  Created by Coen ten Thije Boonkkamp on 05/01/2025.
//
import Stripe_Live_Shared
import Stripe_Types_Models

extension Stripe.Billing.SubscriptionItems.Client {
    public static func live(
        makeRequest:
            @escaping @Sendable (_ route: Stripe.Billing.SubscriptionItems.API) throws -> URLRequest
    ) -> Self {

        @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

        return Self(
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Stripe.Billing.Subscription.Item.self
                )
            },

            update: { id, request in
                try await handleRequest(
                    for: makeRequest(.update(id: id, request: request)),
                    decodingTo: Stripe.Billing.Subscription.Item.self
                )
            },

            retrieve: { id in
                try await handleRequest(
                    for: makeRequest(.retrieve(id: id)),
                    decodingTo: Stripe.Billing.Subscription.Item.self
                )
            },

            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(request: request)),
                    decodingTo: Stripe.Billing.SubscriptionItems.List.Response.self
                )
            },

            delete: { id in
                try await handleRequest(
                    for: makeRequest(.delete(id: id)),
                    decodingTo: DeletedObject<Stripe.Billing.Subscription.Item>.self
                )
            }
        )
    }
}

extension Stripe.Billing.SubscriptionItems {
    public typealias Authenticated = Stripe_Live_Shared.Authenticated<
        Stripe.Billing.SubscriptionItems.API,
        Stripe.Billing.SubscriptionItems.API.Router,
        Stripe.Billing.SubscriptionItems.Client
    >
}

extension Stripe.Billing.SubscriptionItems: @retroactive DependencyKey {
    public static var liveValue: Stripe.Billing.SubscriptionItems.Authenticated {
        try! Stripe.Billing.SubscriptionItems.Authenticated { .live(makeRequest: $0) }
    }
    public static let testValue: Stripe.Billing.SubscriptionItems.Authenticated = liveValue
}

extension Stripe.Billing.SubscriptionItems.API.Router: @retroactive DependencyKey {
    public static let liveValue: Self = .init()
    public static let testValue: Self = .init()
}
