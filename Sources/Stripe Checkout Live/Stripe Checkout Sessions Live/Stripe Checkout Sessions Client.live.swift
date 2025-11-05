import Stripe_Checkout_Types
import Stripe_Live_Shared

extension Stripe.Checkout.Sessions.Client {
    public static func live(
        makeRequest:
            @escaping @Sendable (_ route: Stripe.Checkout.Sessions.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

        return Self(
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Stripe.Checkout.Session.self
                )
            },

            update: { id, request in
                try await handleRequest(
                    for: makeRequest(.update(id: id, request: request)),
                    decodingTo: Stripe.Checkout.Session.self
                )
            },

            retrieve: { id in
                try await handleRequest(
                    for: makeRequest(.retrieve(id: id)),
                    decodingTo: Stripe.Checkout.Session.self
                )
            },

            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(request: request)),
                    decodingTo: Stripe.Checkout.Sessions.List.Response.self
                )
            },

            expire: { id in
                try await handleRequest(
                    for: makeRequest(.expire(id: id)),
                    decodingTo: Stripe.Checkout.Session.self
                )
            },

            lineItems: { id, request in
                try await handleRequest(
                    for: makeRequest(.lineItems(id: id, request: request)),
                    decodingTo: Stripe.Checkout.Sessions.LineItems.Response.self
                )
            }
        )
    }
}

extension Stripe.Checkout.Sessions {
    public typealias Authenticated = Stripe_Live_Shared.Authenticated<
        Stripe.Checkout.Sessions.API,
        Stripe.Checkout.Sessions.API.Router,
        Stripe.Checkout.Sessions.Client
    >
}

extension Stripe.Checkout.Sessions: @retroactive DependencyKey {
    public static var liveValue: Stripe.Checkout.Sessions.Authenticated {
        try! Stripe.Checkout.Sessions.Authenticated { .live(makeRequest: $0) }
    }
    public static let testValue: Stripe.Checkout.Sessions.Authenticated = liveValue
}

extension Stripe.Checkout.Sessions.API.Router: @retroactive DependencyKey {
    public static let liveValue: Self = .init()
    public static let testValue: Self = .init()
}
