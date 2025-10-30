import Dependencies
import Stripe_Live_Shared
import Stripe_Setup_Attempts_Types
import Stripe_Types_Models

extension Stripe.Setup.Attempts.Client {
  public static func live(
    makeRequest: @escaping @Sendable (_ route: Stripe.Setup.Attempts.API) throws -> URLRequest
  ) -> Self {
    @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

    return Self(
      list: { request in
        try await handleRequest(
          for: makeRequest(.list(request: request)),
          decodingTo: Stripe.Setup.Attempts.List.Response.self
        )
      }
    )
  }
}

extension Stripe.Setup.Attempts {
  public typealias Authenticated = Stripe_Live_Shared.Authenticated<
    Stripe.Setup.Attempts.API,
    Stripe.Setup.Attempts.API.Router,
    Stripe.Setup.Attempts.Client
  >
}

extension Stripe.Setup.Attempts: @retroactive DependencyKey {
  public static var liveValue: Stripe.Setup.Attempts.Authenticated {
    try! Stripe.Setup.Attempts.Authenticated { .live(makeRequest: $0) }
  }
  public static let testValue: Stripe.Setup.Attempts.Authenticated = liveValue
}

extension Stripe.Setup.Attempts.API.Router: @retroactive DependencyKey {
  public static let liveValue: Self = .init()
  public static let testValue: Self = .init()
}
