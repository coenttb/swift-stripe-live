//
//  Stripe Payment Method Configurations Client.live.swift
//  swift-stripe-live
//
//  Created on 14/01/2025.
//
import Stripe_Live_Shared
import Stripe_Payment_Methods_Types
import Stripe_Types_Models
import Dependencies

extension Stripe.PaymentMethodConfigurations.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Stripe.PaymentMethodConfigurations.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Stripe.self) var handleRequest
        
        return Self(
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Stripe.PaymentMethodConfigurations.Configuration.self
                )
            },
            
            retrieve: { id in
                try await handleRequest(
                    for: makeRequest(.retrieve(id: id)),
                    decodingTo: Stripe.PaymentMethodConfigurations.Configuration.self
                )
            },
            
            update: { id, request in
                try await handleRequest(
                    for: makeRequest(.update(id: id, request: request)),
                    decodingTo: Stripe.PaymentMethodConfigurations.Configuration.self
                )
            },
            
            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(request: request)),
                    decodingTo: Stripe.PaymentMethodConfigurations.List.Response.self
                )
            }
        )
    }
}

extension Stripe.PaymentMethodConfigurations {
    public typealias Authenticated = Stripe_Live_Shared.Authenticated<
        Stripe.PaymentMethodConfigurations.API,
        Stripe.PaymentMethodConfigurations.API.Router,
        Stripe.PaymentMethodConfigurations.Client
    >
}

extension Stripe.PaymentMethodConfigurations: @retroactive DependencyKey {
    public static var liveValue: Stripe.PaymentMethodConfigurations.Authenticated {
        try! Stripe.PaymentMethodConfigurations.Authenticated { .live(makeRequest: $0) }
    }
    public static let testValue: Stripe.PaymentMethodConfigurations.Authenticated = liveValue
}

extension Stripe.PaymentMethodConfigurations.API.Router: @retroactive DependencyKey {
    public static let liveValue: Self = .init()
    public static let testValue: Self = .init()
}