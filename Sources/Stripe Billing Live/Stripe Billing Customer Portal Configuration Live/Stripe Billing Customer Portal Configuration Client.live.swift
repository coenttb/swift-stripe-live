import Dependencies
import Stripe_Billing_Types
import Stripe_Live_Shared
import Stripe_Types_Models

extension Stripe.Billing.Customer.Portal.Configuration.Client {
  public static func live(
    makeRequest:
      @escaping @Sendable (_ route: Stripe.Billing.Customer.Portal.Configuration.API) throws ->
      URLRequest
  ) -> Self {
    @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

    return Self(
      create: { request in
        try await handleRequest(
          for: makeRequest(.create(request: request)),
          decodingTo: Stripe.Billing.Customer.Portal.Configuration.self
        )
      },
      retrieve: { id in
        try await handleRequest(
          for: makeRequest(.retrieve(id: id)),
          decodingTo: Stripe.Billing.Customer.Portal.Configuration.self
        )
      },
      update: { id, request in
        try await handleRequest(
          for: makeRequest(.update(id: id, request: request)),
          decodingTo: Stripe.Billing.Customer.Portal.Configuration.self
        )
      },
      list: { request in
        try await handleRequest(
          for: makeRequest(.list(request: request)),
          decodingTo: Stripe.Billing.Customer.Portal.Configuration.List.Response.self
        )
      }
    )
  }
}

extension Stripe.Billing.Customer.Portal.Configuration {
  public typealias Authenticated = Stripe_Live_Shared.Authenticated<
    Stripe.Billing.Customer.Portal.Configuration.API,
    Stripe.Billing.Customer.Portal.Configuration.API.Router,
    Stripe.Billing.Customer.Portal.Configuration.Client
  >
}

extension Stripe.Billing.Customer.Portal.Configuration: @retroactive DependencyKey {
  public static var liveValue: Stripe.Billing.Customer.Portal.Configuration.Authenticated {
    try! Stripe.Billing.Customer.Portal.Configuration.Authenticated { .live(makeRequest: $0) }
  }
  public static let testValue: Stripe.Billing.Customer.Portal.Configuration.Authenticated =
    liveValue
}

extension Stripe.Billing.Customer.Portal.Configuration.API.Router: @retroactive DependencyKey {
  public static let liveValue: Self = .init()
  public static let testValue: Self = .init()
}
