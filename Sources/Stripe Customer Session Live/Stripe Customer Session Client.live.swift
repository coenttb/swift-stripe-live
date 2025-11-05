import Stripe_Customer_Session_Types
import Stripe_Live_Shared

extension Stripe.Customers.Customer.Sessions.Client {
    public static func live(
        makeRequest:
            @escaping @Sendable (_ route: Stripe_Customer_Session_Types.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

        return Self(
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Stripe.Customers.Customer.Session.self
                )
            }
        )
    }
}

extension Stripe.Customers.Customer.Sessions {
    public typealias Authenticated = Stripe_Live_Shared.Authenticated<
        Stripe_Customer_Session_Types.API,
        Stripe.Customers.Customer.Sessions.API.Router,
        Stripe.Customers.Customer.Sessions.Client
    >
}

extension Stripe.Customers.Customer.Sessions: @retroactive DependencyKey {
    public static var liveValue: Stripe.Customers.Customer.Sessions.Authenticated {
        try! Stripe.Customers.Customer.Sessions.Authenticated { .live(makeRequest: $0) }
    }
    public static let testValue: Stripe.Customers.Customer.Sessions.Authenticated = liveValue
}

extension Stripe.Customers.Customer.Sessions.API.Router: @retroactive DependencyKey {
    public static let liveValue: Self = .init()
    public static let testValue: Self = .init()
}
