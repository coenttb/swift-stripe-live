import Dependencies
import Stripe_Files_Types
import Stripe_Live_Shared
import Stripe_Types_Models

extension Stripe.Files.Client {
  public static func live(
    makeRequest: @escaping @Sendable (_ route: Stripe.Files.API) throws -> URLRequest
  ) -> Self {
    @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

    return Self(
      create: { request in
        try await handleRequest(
          for: makeRequest(.create(request: request)),
          decodingTo: Stripe.Files.File.self
        )
      },
      retrieve: { id in
        try await handleRequest(
          for: makeRequest(.retrieve(id: id)),
          decodingTo: Stripe.Files.File.self
        )
      },
      list: { request in
        try await handleRequest(
          for: makeRequest(.list(request: request)),
          decodingTo: Stripe.Files.List.Response.self
        )
      }
    )
  }
}

extension Stripe.Files {
  public typealias Authenticated = Stripe_Live_Shared.Authenticated<
    Stripe.Files.API,
    Stripe.Files.API.Router,
    Stripe.Files.Client
  >
}

extension Stripe.Files: @retroactive DependencyKey {
  public static var liveValue: Stripe.Files.Authenticated {
    try! Stripe.Files.Authenticated { .live(makeRequest: $0) }
  }
  public static let testValue: Stripe.Files.Authenticated = liveValue
}

extension Stripe.Files.API.Router: @retroactive DependencyKey {
  public static let liveValue: Self = .init()
  public static let testValue: Self = .init()
}
