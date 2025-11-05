import Dependencies
import Stripe_Billing_Types
//
//  Stripe Billing Alerts Client.live.swift
//  swift-stripe-live
//
//  Created on 14/01/2025.
//
import Stripe_Live_Shared
import Stripe_Types_Models

extension Stripe.Billing.Alerts.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Stripe.Billing.Alerts.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

        return Self(
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Stripe.Billing.Alerts.Alert.self
                )
            },

            retrieve: { id in
                try await handleRequest(
                    for: makeRequest(.retrieve(id: id)),
                    decodingTo: Stripe.Billing.Alerts.Alert.self
                )
            },

            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(request: request)),
                    decodingTo: Stripe.Billing.Alerts.List.Response.self
                )
            },

            activate: { id in
                try await handleRequest(
                    for: makeRequest(.activate(id: id)),
                    decodingTo: Stripe.Billing.Alerts.Alert.self
                )
            },

            archive: { id in
                try await handleRequest(
                    for: makeRequest(.archive(id: id)),
                    decodingTo: Stripe.Billing.Alerts.Alert.self
                )
            },

            deactivate: { id in
                try await handleRequest(
                    for: makeRequest(.deactivate(id: id)),
                    decodingTo: Stripe.Billing.Alerts.Alert.self
                )
            }
        )
    }
}

extension Stripe.Billing.Alerts {
    public typealias Authenticated = Stripe_Live_Shared.Authenticated<
        Stripe.Billing.Alerts.API,
        Stripe.Billing.Alerts.API.Router,
        Stripe.Billing.Alerts.Client
    >
}

extension Stripe.Billing.Alerts: @retroactive DependencyKey {
    public static var liveValue: Stripe.Billing.Alerts.Authenticated {
        try! Stripe.Billing.Alerts.Authenticated { .live(makeRequest: $0) }
    }
    public static let testValue: Stripe.Billing.Alerts.Authenticated = liveValue
}

extension Stripe.Billing.Alerts.API.Router: @retroactive DependencyKey {
    public static let liveValue: Self = .init()
    public static let testValue: Self = .init()
}
