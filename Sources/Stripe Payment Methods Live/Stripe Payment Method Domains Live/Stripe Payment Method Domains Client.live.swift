//
//  Stripe Payment Method Domains Client.live.swift
//  swift-stripe-live
//
//  Created on 14/01/2025.
//
import Stripe_Live_Shared
import Stripe_Payment_Methods_Types
import Stripe_Types_Models
import Dependencies

extension Stripe.PaymentMethodDomains.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Stripe.PaymentMethodDomains.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Stripe.self) var handleRequest
        
        return .init(
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Stripe.PaymentMethodDomain.self
                )
            },
            retrieve: { id in
                try await handleRequest(
                    for: makeRequest(.retrieve(id: id)),
                    decodingTo: Stripe.PaymentMethodDomain.self
                )
            },
            update: { id, request in
                try await handleRequest(
                    for: makeRequest(.update(id: id, request: request)),
                    decodingTo: Stripe.PaymentMethodDomain.self
                )
            },
            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(request: request)),
                    decodingTo: Stripe.PaymentMethodDomains.List.Response.self
                )
            },
            validate: { id in
                try await handleRequest(
                    for: makeRequest(.validate(id: id)),
                    decodingTo: Stripe.PaymentMethodDomain.self
                )
            }
        )
    }
}

extension Stripe.PaymentMethodDomains {
    public typealias Authenticated = Stripe_Live_Shared.Authenticated<
        Stripe.PaymentMethodDomains.API,
        Stripe.PaymentMethodDomains.API.Router,
        Stripe.PaymentMethodDomains.Client
    >
}

extension Stripe.PaymentMethodDomains: @retroactive DependencyKey {
    public static var liveValue: Stripe.PaymentMethodDomains.Authenticated {
        try! Stripe.PaymentMethodDomains.Authenticated { .live(makeRequest: $0) }
    }
    public static let testValue: Stripe.PaymentMethodDomains.Authenticated = liveValue
}

extension Stripe.PaymentMethodDomains.API.Router: @retroactive DependencyKey {
    public static let liveValue: Self = .init()
    public static let testValue: Self = .init()
}