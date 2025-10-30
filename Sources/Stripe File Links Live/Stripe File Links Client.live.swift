import Dependencies
import Stripe_File_Links_Types
import Stripe_Live_Shared
import Stripe_Types_Models

extension Stripe.FileLinks.Client {
  public static func live(
    makeRequest: @escaping @Sendable (_ route: Stripe.FileLinks.API) throws -> URLRequest
  ) -> Self {
    @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

    return Self(
      create: { request in
        try await handleRequest(
          for: makeRequest(.create(request: request)),
          decodingTo: Stripe.FileLinks.FileLink.self
        )
      },
      retrieve: { id in
        try await handleRequest(
          for: makeRequest(.retrieve(id: id)),
          decodingTo: Stripe.FileLinks.FileLink.self
        )
      },
      update: { id, request in
        try await handleRequest(
          for: makeRequest(.update(id: id, request: request)),
          decodingTo: Stripe.FileLinks.FileLink.self
        )
      },
      list: { request in
        try await handleRequest(
          for: makeRequest(.list(request: request)),
          decodingTo: Stripe.FileLinks.List.Response.self
        )
      }
    )
  }
}

extension Stripe.FileLinks {
  public typealias Authenticated = Stripe_Live_Shared.Authenticated<
    Stripe.FileLinks.API,
    Stripe.FileLinks.API.Router,
    Stripe.FileLinks.Client
  >
}

extension Stripe.FileLinks: @retroactive DependencyKey {
  public static var liveValue: Stripe.FileLinks.Authenticated {
    try! Stripe.FileLinks.Authenticated { .live(makeRequest: $0) }
  }
  public static let testValue: Stripe.FileLinks.Authenticated = liveValue
}

extension Stripe.FileLinks.API.Router: @retroactive DependencyKey {
  public static let liveValue: Self = .init()
  public static let testValue: Self = .init()
}
