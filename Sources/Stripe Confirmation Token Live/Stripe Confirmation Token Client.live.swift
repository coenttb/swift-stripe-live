import Dependencies
import Stripe_Confirmation_Token_Types
import Stripe_Live_Shared
import Stripe_Types_Models

extension Stripe.ConfirmationTokenClient {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Stripe.ConfirmationTokenAPI) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

        return Self(
            retrieve: { id in
                try await handleRequest(
                    for: makeRequest(.retrieve(id: id)),
                    decodingTo: ConfirmationToken.self
                )
            }
        )
    }
}

extension Stripe {
    public typealias ConfirmationTokenAuthenticated = Stripe_Live_Shared.Authenticated<
        Stripe.ConfirmationTokenAPI,
        Stripe.ConfirmationTokenAPI.Router,
        Stripe.ConfirmationTokenClient
    >
}

extension Stripe.ConfirmationTokenClient: @retroactive DependencyKey {
    public static var liveValue: Stripe.ConfirmationTokenAuthenticated {
        try! Stripe.ConfirmationTokenAuthenticated { .live(makeRequest: $0) }
    }
    public static let testValue: Stripe.ConfirmationTokenAuthenticated = liveValue
}

extension Stripe.ConfirmationTokenAPI.Router: @retroactive DependencyKey {
    public static let liveValue: Self = .init()
    public static let testValue: Self = .init()
}
