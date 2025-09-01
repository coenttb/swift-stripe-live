import Stripe_Live_Shared
import Stripe_Balance_Transactions_Types
import Stripe_Types_Models
import Dependencies

extension Stripe.BalanceTransactions.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Stripe.BalanceTransactions.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Stripe.self) var handleRequest
        
        return Self(
            retrieve: { id in
                try await handleRequest(
                    for: makeRequest(.retrieve(id: id)),
                    decodingTo: Stripe.Balance.Transaction.self
                )
            },
            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(request: request)),
                    decodingTo: Stripe.BalanceTransactions.List.Response.self
                )
            }
        )
    }
}

extension Stripe.BalanceTransactions {
    public typealias Authenticated = Stripe_Live_Shared.Authenticated<
        Stripe.BalanceTransactions.API,
        Stripe.BalanceTransactions.API.Router,
        Stripe.BalanceTransactions.Client
    >
}

extension Stripe.BalanceTransactions: @retroactive DependencyKey {
    public static var liveValue: Stripe.BalanceTransactions.Authenticated {
        try! Stripe.BalanceTransactions.Authenticated { .live(makeRequest: $0) }
    }
    public static let testValue: Stripe.BalanceTransactions.Authenticated = liveValue
}

extension Stripe.BalanceTransactions.API.Router: @retroactive DependencyKey {
    public static let liveValue: Self = .init()
    public static let testValue: Self = .init()
}