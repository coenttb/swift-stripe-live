import Dependencies
//
//  Stripe Tax Calculations Client.live.swift
//  swift-stripe-live
//
//  Created on 14/01/2025.
//
import Stripe_Live_Shared
import Stripe_Tax_Calculations_Types
import Stripe_Types_Models

extension Stripe.Tax.Calculations.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Stripe.Tax.Calculations.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

        return Self(
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Stripe.Tax.Calculation.self
                )
            },

            retrieve: { id in
                try await handleRequest(
                    for: makeRequest(.retrieve(id: id)),
                    decodingTo: Stripe.Tax.Calculation.self
                )
            },

            listLineItems: { id, request in
                try await handleRequest(
                    for: makeRequest(.listLineItems(id: id, request: request)),
                    decodingTo: Stripe.Tax.Calculations.ListLineItems.Response.self
                )
            }
        )
    }
}

extension Stripe.Tax.Calculations {
    public typealias Authenticated = Stripe_Live_Shared.Authenticated<
        Stripe.Tax.Calculations.API,
        Stripe.Tax.Calculations.API.Router,
        Stripe.Tax.Calculations.Client
    >
}

extension Stripe.Tax.Calculations: @retroactive DependencyKey {
    public static var liveValue: Stripe.Tax.Calculations.Authenticated {
        try! Stripe.Tax.Calculations.Authenticated { .live(makeRequest: $0) }
    }
    public static let testValue: Stripe.Tax.Calculations.Authenticated = liveValue
}

extension Stripe.Tax.Calculations.API.Router: @retroactive DependencyKey {
    public static let liveValue: Self = .init()
    public static let testValue: Self = .init()
}
