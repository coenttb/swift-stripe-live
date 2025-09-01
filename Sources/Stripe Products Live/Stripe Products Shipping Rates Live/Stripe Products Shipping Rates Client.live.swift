import Stripe_Live_Shared
import Stripe_Products_Types
import Stripe_Types_Models
import Dependencies

extension Stripe.Products.ShippingRates.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Stripe.Products.ShippingRates.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Stripe.self) var handleRequest
        
        return Self(
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Stripe.Products.Shipping.Rate.self
                )
            },
            retrieve: { id in
                try await handleRequest(
                    for: makeRequest(.retrieve(id: id)),
                    decodingTo: Stripe.Products.Shipping.Rate.self
                )
            },
            update: { id, request in
                try await handleRequest(
                    for: makeRequest(.update(id: id, request: request)),
                    decodingTo: Stripe.Products.Shipping.Rate.self
                )
            },
            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(request: request)),
                    decodingTo: Stripe.Products.ShippingRates.List.Response.self
                )
            }
        )
    }
}

extension Stripe.Products.ShippingRates {
    public typealias Authenticated = Stripe_Live_Shared.Authenticated<
        Stripe.Products.ShippingRates.API,
        Stripe.Products.ShippingRates.API.Router,
        Stripe.Products.ShippingRates.Client
    >
}

extension Stripe.Products.ShippingRates: @retroactive DependencyKey {
    public static var liveValue: Stripe.Products.ShippingRates.Authenticated {
        try! Stripe.Products.ShippingRates.Authenticated { .live(makeRequest: $0) }
    }
    public static let testValue: Stripe.Products.ShippingRates.Authenticated = liveValue
}

extension Stripe.Products.ShippingRates.API.Router: @retroactive DependencyKey {
    public static let liveValue: Self = .init()
    public static let testValue: Self = .init()
}
