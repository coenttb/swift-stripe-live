//
//  Products Prices Client.live.swift
//  coenttb-stripe
//
//  Created by Coen ten Thije Boonkkamp on 05/01/2025.
//
import Stripe_Live_Shared
import Stripe_Products_Types

extension Stripe.Products.Prices.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Stripe.Products.Prices.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

        return Self(
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Stripe.Products.Price.self
                )
            },

            update: { id, request in
                try await handleRequest(
                    for: makeRequest(.update(id: id, request: request)),
                    decodingTo: Stripe.Products.Price.self
                )
            },

            retrieve: { id in
                try await handleRequest(
                    for: makeRequest(.retrieve(id: id)),
                    decodingTo: Stripe.Products.Price.self
                )
            },

            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(request: request)),
                    decodingTo: Stripe.Products.Prices.List.Response.self
                )
            },

            search: { request in
                try await handleRequest(
                    for: makeRequest(.search(request: request)),
                    decodingTo: Stripe.Products.Prices.Search.Response.self
                )
            }
        )
    }
}

extension Stripe.Products.Prices {
    public typealias Authenticated = Stripe_Live_Shared.Authenticated<
        Stripe.Products.Prices.API,
        Stripe.Products.Prices.API.Router,
        Stripe.Products.Prices.Client
    >
}

extension Stripe.Products.Prices: @retroactive DependencyKey {
    public static var liveValue: Stripe.Products.Prices.Authenticated {
        try! Stripe.Products.Prices.Authenticated { .live(makeRequest: $0) }
    }
    public static let testValue: Stripe.Products.Prices.Authenticated = liveValue
}

extension Stripe.Products.Prices.API.Router: @retroactive DependencyKey {
    public static let liveValue: Self = .init()
    public static let testValue: Self = .init()
}
