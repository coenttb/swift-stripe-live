import Stripe_Live_Shared
import Stripe_Payment_Link_Types

extension Stripe.PaymentLinks.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Stripe.PaymentLinks.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

        return Self(
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Stripe.PaymentLink.self
                )
            },

            update: { id, request in
                try await handleRequest(
                    for: makeRequest(.update(id: id, request: request)),
                    decodingTo: Stripe.PaymentLink.self
                )
            },

            retrieve: { id in
                try await handleRequest(
                    for: makeRequest(.retrieve(id: id)),
                    decodingTo: Stripe.PaymentLink.self
                )
            },

            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(request: request)),
                    decodingTo: Stripe.PaymentLinks.List.Response.self
                )
            },

            lineItems: { id, request in
                try await handleRequest(
                    for: makeRequest(.lineItems(id: id, request: request)),
                    decodingTo: Stripe.PaymentLinks.LineItems.Response.self
                )
            }
        )
    }
}

extension Stripe.PaymentLinks {
    public typealias Authenticated = Stripe_Live_Shared.Authenticated<
        Stripe.PaymentLinks.API,
        Stripe.PaymentLinks.API.Router,
        Stripe.PaymentLinks.Client
    >
}

extension Stripe.PaymentLinks: @retroactive DependencyKey {
    public static var liveValue: Stripe.PaymentLinks.Authenticated {
        try! Stripe.PaymentLinks.Authenticated { .live(makeRequest: $0) }
    }
    public static let testValue: Stripe.PaymentLinks.Authenticated = liveValue
}

extension Stripe.PaymentLinks.API.Router: @retroactive DependencyKey {
    public static let liveValue: Self = .init()
    public static let testValue: Self = .init()
}
