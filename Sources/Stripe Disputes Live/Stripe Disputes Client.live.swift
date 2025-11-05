import Dependencies
import Stripe_Disputes_Types
import Stripe_Live_Shared
import Stripe_Types_Models

extension Stripe.Disputes.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Stripe.Disputes.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

        return Self(
            retrieve: { id in
                try await handleRequest(
                    for: makeRequest(.retrieve(id: id)),
                    decodingTo: Stripe.Disputes.Dispute.self
                )
            },
            update: { id, request in
                try await handleRequest(
                    for: makeRequest(.update(id: id, request: request)),
                    decodingTo: Stripe.Disputes.Dispute.self
                )
            },
            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(request: request)),
                    decodingTo: Stripe.Disputes.List.Response.self
                )
            },
            close: { id in
                try await handleRequest(
                    for: makeRequest(.close(id: id)),
                    decodingTo: Stripe.Disputes.Dispute.self
                )
            }
        )
    }
}

extension Stripe.Disputes {
    public typealias Authenticated = Stripe_Live_Shared.Authenticated<
        Stripe.Disputes.API,
        Stripe.Disputes.API.Router,
        Stripe.Disputes.Client
    >
}

extension Stripe.Disputes: @retroactive DependencyKey {
    public static var liveValue: Stripe.Disputes.Authenticated {
        try! Stripe.Disputes.Authenticated { .live(makeRequest: $0) }
    }
    public static let testValue: Stripe.Disputes.Authenticated = liveValue
}

extension Stripe.Disputes.API.Router: @retroactive DependencyKey {
    public static let liveValue: Self = .init()
    public static let testValue: Self = .init()
}
