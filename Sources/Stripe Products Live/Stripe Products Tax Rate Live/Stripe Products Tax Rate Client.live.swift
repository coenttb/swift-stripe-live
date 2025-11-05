import Dependencies
import Stripe_Live_Shared
import Stripe_Products_Types
import Stripe_Types_Models

extension Stripe.Products.TaxRates.Client {
    public static func live(
        makeRequest:
            @escaping @Sendable (_ route: Stripe.Products.TaxRates.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

        return Self(
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Stripe.Tax.Rate.self
                )
            },
            retrieve: { id in
                try await handleRequest(
                    for: makeRequest(.retrieve(id: id)),
                    decodingTo: Stripe.Tax.Rate.self
                )
            },
            update: { id, request in
                try await handleRequest(
                    for: makeRequest(.update(id: id, request: request)),
                    decodingTo: Stripe.Tax.Rate.self
                )
            },
            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(request: request)),
                    decodingTo: Stripe.Products.TaxRates.List.Response.self
                )
            }
        )
    }
}

extension Stripe.Products.TaxRates {
    public typealias Authenticated = Stripe_Live_Shared.Authenticated<
        Stripe.Products.TaxRates.API,
        Stripe.Products.TaxRates.API.Router,
        Stripe.Products.TaxRates.Client
    >
}

extension Stripe.Products.TaxRates: @retroactive DependencyKey {
    public static var liveValue: Stripe.Products.TaxRates.Authenticated {
        try! Stripe.Products.TaxRates.Authenticated { .live(makeRequest: $0) }
    }
    public static let testValue: Stripe.Products.TaxRates.Authenticated = liveValue
}

extension Stripe.Products.TaxRates.API.Router: @retroactive DependencyKey {
    public static let liveValue: Self = .init()
    public static let testValue: Self = .init()
}
