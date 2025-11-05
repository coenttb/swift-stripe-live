//
//  Products Client.live.swift
//  coenttb-stripe
//
//  Created by Coen ten Thije Boonkkamp on 05/01/2025.
//
import Stripe_Live_Shared
import Stripe_Products_Types

extension Stripe.Products.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Stripe.Products.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

        return Self(
            products: .live(
                makeRequest: { try makeRequest(.products($0)) }
            ),
            prices: .live(
                makeRequest: { try makeRequest(.prices($0)) }
            ),
            coupons: .live(
                makeRequest: { try makeRequest(.coupons($0)) }
            ),
            promotionCodes: .live(
                makeRequest: { try makeRequest(.promotionCodes($0)) }
            ),
            discounts: .live(
                makeRequest: { try makeRequest(.discounts($0)) }
            ),
            taxRates: .live(
                makeRequest: { try makeRequest(.taxRates($0)) }
            ),
            shippingRates: .live(
                makeRequest: { try makeRequest(.shippingRates($0)) }
            )
        )
    }
}

extension Stripe.Products {
    public typealias Authenticated = Stripe_Live_Shared.Authenticated<
        Stripe.Products.API,
        Stripe.Products.API.Router,
        Stripe.Products.Client
    >
}

extension Stripe.Products: @retroactive DependencyKey {
    public static var liveValue: Stripe.Products.Authenticated {
        try! Stripe.Products.Authenticated { .live(makeRequest: $0) }
    }
    public static let testValue: Stripe.Products.Authenticated = liveValue
}

extension Stripe.Products.API.Router: @retroactive DependencyKey {
    public static let liveValue: Self = .init()
    public static let testValue: Self = .init()
}
