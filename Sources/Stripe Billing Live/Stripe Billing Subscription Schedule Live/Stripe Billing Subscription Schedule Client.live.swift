//
//  Stripe Billing Subscription Schedule Client.live.swift
//  swift-stripe-live
//
//  Created on 15/01/2025.
//

import Dependencies
import Stripe_Billing_Types
import Stripe_Live_Shared
import Stripe_Types_Models

extension Stripe.Billing.Subscription.Schedule.Client {
    public static func live(
        makeRequest:
            @escaping @Sendable (_ route: Stripe.Billing.Subscription.Schedule.API) throws ->
            URLRequest
    ) -> Self {

        @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

        return Self(
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Stripe.Billing.Subscription.Schedule.self
                )
            },

            retrieve: { id in
                try await handleRequest(
                    for: makeRequest(.retrieve(id: id)),
                    decodingTo: Stripe.Billing.Subscription.Schedule.self
                )
            },

            update: { id, request in
                try await handleRequest(
                    for: makeRequest(.update(id: id, request: request)),
                    decodingTo: Stripe.Billing.Subscription.Schedule.self
                )
            },

            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(request: request)),
                    decodingTo: Stripe.Billing.Subscription.Schedule.List.Response.self
                )
            },

            cancel: { id, request in
                try await handleRequest(
                    for: makeRequest(.cancel(id: id, request: request)),
                    decodingTo: Stripe.Billing.Subscription.Schedule.self
                )
            },

            release: { id, request in
                try await handleRequest(
                    for: makeRequest(.release(id: id, request: request)),
                    decodingTo: Stripe.Billing.Subscription.Schedule.self
                )
            }
        )
    }
}

extension Stripe.Billing.Subscription.Schedule {
    public typealias Authenticated = Stripe_Live_Shared.Authenticated<
        Stripe.Billing.Subscription.Schedule.API,
        Stripe.Billing.Subscription.Schedule.API.Router,
        Stripe.Billing.Subscription.Schedule.Client
    >
}

extension Stripe.Billing.Subscription.Schedule: @retroactive DependencyKey {
    public static var liveValue: Stripe.Billing.Subscription.Schedule.Authenticated {
        try! Stripe.Billing.Subscription.Schedule.Authenticated { .live(makeRequest: $0) }
    }
    public static let testValue: Stripe.Billing.Subscription.Schedule.Authenticated = liveValue
}

extension Stripe.Billing.Subscription.Schedule.API.Router: @retroactive DependencyKey {
    public static let liveValue: Self = .init()
    public static let testValue: Self = .init()
}
