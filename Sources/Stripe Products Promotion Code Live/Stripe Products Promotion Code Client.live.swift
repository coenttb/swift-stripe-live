//
//  Stripe Products Promotion Code Client.live.swift
//  swift-stripe-live
//
//  Created on 14/01/2025.
//
import Stripe_Live_Shared
import Stripe_Products_Promotion_Codes_Types
import Stripe_Types_Models
import Dependencies

extension Stripe.Products.PromotionCodes.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Stripe.Products.PromotionCodes.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Stripe.self) var handleRequest
        
        return Self(
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Stripe.Products.PromotionCode.self
                )
            },
            
            retrieve: { id in
                try await handleRequest(
                    for: makeRequest(.retrieve(id: id)),
                    decodingTo: Stripe.Products.PromotionCode.self
                )
            },
            
            update: { id, request in
                try await handleRequest(
                    for: makeRequest(.update(id: id, request: request)),
                    decodingTo: Stripe.Products.PromotionCode.self
                )
            },
            
            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(request: request)),
                    decodingTo: Stripe.Products.PromotionCodes.List.Response.self
                )
            }
        )
    }
}

extension Stripe.Products.PromotionCodes {
    public typealias Authenticated = Stripe_Live_Shared.Authenticated<
        Stripe.Products.PromotionCodes.API,
        Stripe.Products.PromotionCodes.API.Router,
        Stripe.Products.PromotionCodes.Client
    >
}

extension Stripe.Products.PromotionCodes: @retroactive DependencyKey {
    public static var liveValue: Stripe.Products.PromotionCodes.Authenticated {
        try! Stripe.Products.PromotionCodes.Authenticated { .live(makeRequest: $0) }
    }
    public static let testValue: Stripe.Products.PromotionCodes.Authenticated = liveValue
}

extension Stripe.Products.PromotionCodes.API.Router: @retroactive DependencyKey {
    public static let liveValue: Self = .init()
    public static let testValue: Self = .init()
}