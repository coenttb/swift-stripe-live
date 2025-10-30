import Dependencies
import Stripe_Live_Shared
import Stripe_Refunds_Types
import Stripe_Types_Models

extension Stripe.Refunds.Client {
  public static func live(
    makeRequest: @escaping @Sendable (_ route: Stripe.Refunds.API) throws -> URLRequest
  ) -> Self {
    @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

    return Self(
      create: { request in
        try await handleRequest(
          for: makeRequest(.create(request: request)),
          decodingTo: Stripe.Refunds.Refund.self
        )
      },
      retrieve: { id in
        try await handleRequest(
          for: makeRequest(.retrieve(id: id)),
          decodingTo: Stripe.Refunds.Refund.self
        )
      },
      update: { id, request in
        try await handleRequest(
          for: makeRequest(.update(id: id, request: request)),
          decodingTo: Stripe.Refunds.Refund.self
        )
      },
      list: { request in
        try await handleRequest(
          for: makeRequest(.list(request: request)),
          decodingTo: Stripe.Refunds.List.Response.self
        )
      },
      cancel: { id in
        try await handleRequest(
          for: makeRequest(.cancel(id: id)),
          decodingTo: Stripe.Refunds.Refund.self
        )
      }
    )
  }
}

extension Stripe.Refunds {
  public typealias Authenticated = Stripe_Live_Shared.Authenticated<
    Stripe.Refunds.API,
    Stripe.Refunds.API.Router,
    Stripe.Refunds.Client
  >
}

extension Stripe.Refunds: @retroactive DependencyKey {
  public static var liveValue: Stripe.Refunds.Authenticated {
    try! Stripe.Refunds.Authenticated { .live(makeRequest: $0) }
  }
  public static let testValue: Stripe.Refunds.Authenticated = liveValue
}

extension Stripe.Refunds.API.Router: @retroactive DependencyKey {
  public static let liveValue: Self = .init()
  public static let testValue: Self = .init()
}
