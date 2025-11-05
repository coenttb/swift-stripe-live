import Dependencies
//
//  Stripe Payment Methods Sources Client.live.swift
//  swift-stripe-live
//
//  Created on 14/01/2025.
//
import Stripe_Live_Shared
import Stripe_Payment_Methods_Types
import Stripe_Types_Models

extension Stripe.PaymentMethods.Sources.Client {
    public static func live(
        makeRequest:
            @escaping @Sendable (_ route: Stripe.PaymentMethods.Sources.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

        return Self(
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Source.self
                )
            },

            retrieve: { id in
                try await handleRequest(
                    for: makeRequest(.retrieve(id: id)),
                    decodingTo: Source.self
                )
            },

            update: { id, request in
                try await handleRequest(
                    for: makeRequest(.update(id: id, request: request)),
                    decodingTo: Source.self
                )
            },

            attach: { customerId, sourceId in
                try await handleRequest(
                    for: makeRequest(.attach(customerId: customerId, source: sourceId)),
                    decodingTo: Source.self
                )
            },

            detach: { customerId, sourceId in
                try await handleRequest(
                    for: makeRequest(.detach(customerId: customerId, sourceId: sourceId)),
                    decodingTo: Source.self
                )
            }
        )
    }
}

extension Stripe.PaymentMethods.Sources {
    public typealias Authenticated = Stripe_Live_Shared.Authenticated<
        Stripe.PaymentMethods.Sources.API,
        Stripe.PaymentMethods.Sources.API.Router,
        Stripe.PaymentMethods.Sources.Client
    >
}

extension Stripe.PaymentMethods.Sources: @retroactive DependencyKey {
    public static var liveValue: Stripe.PaymentMethods.Sources.Authenticated {
        try! Stripe.PaymentMethods.Sources.Authenticated { .live(makeRequest: $0) }
    }
    public static let testValue: Stripe.PaymentMethods.Sources.Authenticated = liveValue
}

extension Stripe.PaymentMethods.Sources.API.Router: @retroactive DependencyKey {
    public static let liveValue: Self = .init()
    public static let testValue: Self = .init()
}
