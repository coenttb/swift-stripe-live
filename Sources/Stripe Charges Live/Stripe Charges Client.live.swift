import Dependencies
import Stripe_Charges_Types
import Stripe_Live_Shared
import Stripe_Types_Models

extension Stripe.Charges.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Stripe.Charges.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

        return Self(
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Stripe.Charges.Charge.self
                )
            },
            retrieve: { id in
                try await handleRequest(
                    for: makeRequest(.retrieve(id: id)),
                    decodingTo: Stripe.Charges.Charge.self
                )
            },
            update: { id, request in
                try await handleRequest(
                    for: makeRequest(.update(id: id, request: request)),
                    decodingTo: Stripe.Charges.Charge.self
                )
            },
            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(request: request)),
                    decodingTo: Stripe.Charges.List.Response.self
                )
            },
            capture: { id, request in
                try await handleRequest(
                    for: makeRequest(.capture(id: id, request: request)),
                    decodingTo: Stripe.Charges.Charge.self
                )
            },
            search: { request in
                try await handleRequest(
                    for: makeRequest(.search(request: request)),
                    decodingTo: Stripe.Charges.Search.Response.self
                )
            }
        )
    }
}

extension Stripe.Charges {
    public typealias Authenticated = Stripe_Live_Shared.Authenticated<
        Stripe.Charges.API,
        Stripe.Charges.API.Router,
        Stripe.Charges.Client
    >
}

extension Stripe.Charges: @retroactive DependencyKey {
    public static var liveValue: Stripe.Charges.Authenticated {
        try! Stripe.Charges.Authenticated { .live(makeRequest: $0) }
    }
    public static let testValue: Stripe.Charges.Authenticated = liveValue
}

extension Stripe.Charges.API.Router: @retroactive DependencyKey {
    public static let liveValue: Self = .init()
    public static let testValue: Self = .init()
}
