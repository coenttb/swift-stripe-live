import Dependencies
import Stripe_Events_Types
import Stripe_Live_Shared
import Stripe_Types_Models

extension Stripe.Events.Client {
  public static func live(
    makeRequest: @escaping @Sendable (_ route: Stripe.Events.API) throws -> URLRequest
  ) -> Self {
    @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

    return Self(
      retrieve: { id in
        try await handleRequest(
          for: makeRequest(.retrieve(id: id)),
          decodingTo: Stripe.Events.Event.self
        )
      },
      list: { request in
        try await handleRequest(
          for: makeRequest(.list(request: request)),
          decodingTo: Stripe.Events.List.Response.self
        )
      }
    )
  }
}

extension Stripe.Events {
  public typealias Authenticated = Stripe_Live_Shared.Authenticated<
    Stripe.Events.API,
    Stripe.Events.API.Router,
    Stripe.Events.Client
  >
}

extension Stripe.Events: @retroactive DependencyKey {
  public static var liveValue: Stripe.Events.Authenticated {
    try! Stripe.Events.Authenticated { .live(makeRequest: $0) }
  }
  public static let testValue: Stripe.Events.Authenticated = liveValue
}

extension Stripe.Events.API.Router: @retroactive DependencyKey {
  public static let liveValue: Self = .init()
  public static let testValue: Self = .init()
}
