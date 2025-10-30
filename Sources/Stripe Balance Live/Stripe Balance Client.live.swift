import Dependencies
import Stripe_Balance_Types
import Stripe_Live_Shared
import Stripe_Types_Models

extension Stripe.Balance.Client {
  public static func live(
    makeRequest: @escaping @Sendable (_ route: Stripe.Balance.API) throws -> URLRequest
  ) -> Self {
    @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

    return Self(
      retrieve: {
        try await handleRequest(
          for: makeRequest(.retrieve),
          decodingTo: Stripe.Balance.self
        )
      }
    )
  }
}

extension Stripe.Balance {
  public typealias Authenticated = Stripe_Live_Shared.Authenticated<
    Stripe.Balance.API,
    Stripe.Balance.API.Router,
    Stripe.Balance.Client
  >
}

extension Stripe.Balance: @retroactive DependencyKey {
  public static var liveValue: Stripe.Balance.Authenticated {
    try! Stripe.Balance.Authenticated { .live(makeRequest: $0) }
  }
  public static let testValue: Stripe.Balance.Authenticated = liveValue
}

extension Stripe.Balance.API.Router: @retroactive DependencyKey {
  public static let liveValue: Self = .init()
  public static let testValue: Self = .init()
}
