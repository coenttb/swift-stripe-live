import Stripe_Checkout_Types
import Stripe_Live_Shared

extension Stripe.Checkout.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Stripe.Checkout.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

        return Self(
            sessions: .live(
                makeRequest: { try makeRequest(.sessions($0)) }
            )
        )
    }
}

extension Stripe.Checkout {
    public typealias Authenticated = Stripe_Live_Shared.Authenticated<
        Stripe.Checkout.API,
        Stripe.Checkout.API.Router,
        Stripe.Checkout.Client
    >
}

extension Stripe.Checkout: @retroactive DependencyKey {
    public static var liveValue: Stripe.Checkout.Authenticated {
        try! Stripe.Checkout.Authenticated { .live(makeRequest: $0) }
    }
    public static let testValue: Stripe.Checkout.Authenticated = liveValue
}

extension Stripe.Checkout.API.Router: @retroactive DependencyKey {
    public static let liveValue: Self = .init()
    public static let testValue: Self = .init()
}
