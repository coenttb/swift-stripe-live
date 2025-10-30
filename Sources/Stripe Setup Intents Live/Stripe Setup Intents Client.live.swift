import Dependencies
import Stripe_Live_Shared
import Stripe_Setup_Intents_Types
import Stripe_Types_Models

extension Stripe.Setup.Intents.Client {
  public static func live(
    makeRequest: @escaping @Sendable (_ route: Stripe.Setup.Intents.API) throws -> URLRequest
  ) -> Self {
    @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

    return Self(
      create: { request in
        try await handleRequest(
          for: makeRequest(.create(request: request)),
          decodingTo: Stripe.Setup.Intent.self
        )
      },
      retrieve: { id in
        try await handleRequest(
          for: makeRequest(.retrieve(id: id)),
          decodingTo: Stripe.Setup.Intent.self
        )
      },
      update: { id, request in
        try await handleRequest(
          for: makeRequest(.update(id: id, request: request)),
          decodingTo: Stripe.Setup.Intent.self
        )
      },
      list: { request in
        try await handleRequest(
          for: makeRequest(.list(request: request)),
          decodingTo: Stripe.Setup.Intents.List.Response.self
        )
      },
      confirm: { id, request in
        try await handleRequest(
          for: makeRequest(.confirm(id: id, request: request)),
          decodingTo: Stripe.Setup.Intent.self
        )
      },
      cancel: { id, request in
        try await handleRequest(
          for: makeRequest(.cancel(id: id, request: request)),
          decodingTo: Stripe.Setup.Intent.self
        )
      },
      verifyMicrodeposits: { id, request in
        try await handleRequest(
          for: makeRequest(.verifyMicrodeposits(id: id, request: request)),
          decodingTo: Stripe.Setup.Intent.self
        )
      }
    )
  }
}

extension Stripe.Setup.Intents {
  public typealias Authenticated = Stripe_Live_Shared.Authenticated<
    Stripe.Setup.Intents.API,
    Stripe.Setup.Intents.API.Router,
    Stripe.Setup.Intents.Client
  >
}

extension Stripe.Setup.Intents: @retroactive DependencyKey {
  public static var liveValue: Stripe.Setup.Intents.Authenticated {
    try! Stripe.Setup.Intents.Authenticated { .live(makeRequest: $0) }
  }
  public static let testValue: Stripe.Setup.Intents.Authenticated = liveValue
}

extension Stripe.Setup.Intents.API.Router: @retroactive DependencyKey {
  public static let liveValue: Self = .init()
  public static let testValue: Self = .init()
}
