import Dependencies
import Stripe_Billing_Types
import Stripe_Live_Shared
import Stripe_Types_Models

extension Stripe.Billing.Invoices.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Stripe.Billing.Invoices.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

        return Self(
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Stripe.Billing.Invoice.self
                )
            },

            createPreview: { request in
                try await handleRequest(
                    for: makeRequest(.createPreview(request: request)),
                    decodingTo: Stripe.Billing.Invoice.self
                )
            },

            retrieve: { id in
                try await handleRequest(
                    for: makeRequest(.retrieve(id: id)),
                    decodingTo: Stripe.Billing.Invoice.self
                )
            },

            update: { id, request in
                try await handleRequest(
                    for: makeRequest(.update(id: id, request: request)),
                    decodingTo: Stripe.Billing.Invoice.self
                )
            },

            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(request: request)),
                    decodingTo: Stripe.Billing.Invoices.List.Response.self
                )
            },

            delete: { id in
                try await handleRequest(
                    for: makeRequest(.delete(id: id)),
                    decodingTo: DeletedObject<Stripe.Billing.Invoice>.self
                )
            },

            finalize: { id, request in
                try await handleRequest(
                    for: makeRequest(.finalize(id: id, request: request)),
                    decodingTo: Stripe.Billing.Invoice.self
                )
            },

            pay: { id, request in
                try await handleRequest(
                    for: makeRequest(.pay(id: id, request: request)),
                    decodingTo: Stripe.Billing.Invoice.self
                )
            },

            send: { id, request in
                try await handleRequest(
                    for: makeRequest(.send(id: id, request: request)),
                    decodingTo: Stripe.Billing.Invoice.self
                )
            },

            void: { id, request in
                try await handleRequest(
                    for: makeRequest(.void(id: id, request: request)),
                    decodingTo: Stripe.Billing.Invoice.self
                )
            }
        )
    }
}

extension Stripe.Billing.Invoices {
    public typealias Authenticated = Stripe_Live_Shared.Authenticated<
        Stripe.Billing.Invoices.API,
        Stripe.Billing.Invoices.API.Router,
        Stripe.Billing.Invoices.Client
    >
}

extension Stripe.Billing.Invoices: @retroactive DependencyKey {
    public static var liveValue: Stripe.Billing.Invoices.Authenticated {
        try! Stripe.Billing.Invoices.Authenticated { .live(makeRequest: $0) }
    }
    public static let testValue: Stripe.Billing.Invoices.Authenticated = liveValue
}

extension Stripe.Billing.Invoices.API.Router: @retroactive DependencyKey {
    public static let liveValue: Self = .init()
    public static let testValue: Self = .init()
}
