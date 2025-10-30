import Dependencies
import Stripe_Live_Shared
import Stripe_Mandates_Types
import Stripe_Types_Models

extension Stripe.Mandates.Client {
  public static func live(
    makeRequest: @escaping @Sendable (_ route: Stripe.Mandates.API) throws -> URLRequest
  ) -> Self {
    @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

    return Self(
      retrieve: { id in
        try await handleRequest(
          for: makeRequest(.retrieve(id: id)),
          decodingTo: Stripe.Mandates.Mandate.self
        )
      }
    )
  }
}

extension Stripe.Mandates {
  public typealias Authenticated = Stripe_Live_Shared.Authenticated<
    Stripe.Mandates.API,
    Stripe.Mandates.API.Router,
    Stripe.Mandates.Client
  >
}

extension Stripe.Mandates: @retroactive DependencyKey {
  public static var liveValue: Stripe.Mandates.Authenticated {
    try! Stripe.Mandates.Authenticated { .live(makeRequest: $0) }
  }
  public static let testValue: Stripe.Mandates.Authenticated = liveValue
}

extension Stripe.Mandates.API.Router: @retroactive DependencyKey {
  public static let liveValue: Self = .init()
  public static let testValue: Self = .init()
}
