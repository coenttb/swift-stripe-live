import Dependencies
import Stripe_Live_Shared
import Stripe_Payouts_Types
import Stripe_Types_Models

extension Stripe.Payouts.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Stripe.Payouts.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

        return Self(
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Stripe.Payouts.Payout.self
                )
            },
            retrieve: { id in
                try await handleRequest(
                    for: makeRequest(.retrieve(id: id)),
                    decodingTo: Stripe.Payouts.Payout.self
                )
            },
            update: { id, request in
                try await handleRequest(
                    for: makeRequest(.update(id: id, request: request)),
                    decodingTo: Stripe.Payouts.Payout.self
                )
            },
            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(request: request)),
                    decodingTo: Stripe.Payouts.List.Response.self
                )
            },
            cancel: { id in
                try await handleRequest(
                    for: makeRequest(.cancel(id: id)),
                    decodingTo: Stripe.Payouts.Payout.self
                )
            },
            reverse: { id, request in
                try await handleRequest(
                    for: makeRequest(.reverse(id: id, request: request)),
                    decodingTo: Stripe.Payouts.Payout.self
                )
            }
        )
    }
}

extension Stripe.Payouts {
    public typealias Authenticated = Stripe_Live_Shared.Authenticated<
        Stripe.Payouts.API,
        Stripe.Payouts.API.Router,
        Stripe.Payouts.Client
    >
}

extension Stripe.Payouts: @retroactive DependencyKey {
    public static var liveValue: Stripe.Payouts.Authenticated {
        try! Stripe.Payouts.Authenticated { .live(makeRequest: $0) }
    }
    public static let testValue: Stripe.Payouts.Authenticated = liveValue
}

extension Stripe.Payouts.API.Router: @retroactive DependencyKey {
    public static let liveValue: Self = .init()
    public static let testValue: Self = .init()
}
