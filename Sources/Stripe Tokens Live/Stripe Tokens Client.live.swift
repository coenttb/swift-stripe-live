import Stripe_Live_Shared
import Stripe_Tokens_Types
import Stripe_Types_Models
import Dependencies

extension Stripe.Tokens.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Stripe.Tokens.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Stripe.self) var handleRequest
        
        return Self(
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Stripe.Tokens.Token.self
                )
            },
            retrieve: { id in
                try await handleRequest(
                    for: makeRequest(.retrieve(id: id)),
                    decodingTo: Stripe.Tokens.Token.self
                )
            }
        )
    }
}

extension Stripe.Tokens {
    public typealias Authenticated = Stripe_Live_Shared.Authenticated<
        Stripe.Tokens.API,
        Stripe.Tokens.API.Router,
        Stripe.Tokens.Client
    >
}

extension Stripe.Tokens: @retroactive DependencyKey {
    public static var liveValue: Stripe.Tokens.Authenticated {
        try! Stripe.Tokens.Authenticated { .live(makeRequest: $0) }
    }
    public static let testValue: Stripe.Tokens.Authenticated = liveValue
}

extension Stripe.Tokens.API.Router: @retroactive DependencyKey {
    public static let liveValue: Self = .init()
    public static let testValue: Self = .init()
}