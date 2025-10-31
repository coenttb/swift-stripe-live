//
//  File.swift
//  rule-law
//
//  Created by Coen ten Thije Boonkkamp on 05/01/2025.
//

import Authenticating
import Foundation
import URLRouting

public typealias Authenticated<
  API: Equatable & Sendable,
  APIRouter: ParserPrinter & Sendable,
  Client: Sendable
> = Authenticating<
  BearerAuth,
  StripeAuthRouter,
  API,
  APIRouter,
  Client
> where APIRouter.Output == API, APIRouter.Input == URLRequestData

extension Authenticated {
  public init(
    router: APIRouter,
    buildClient:
      @escaping @Sendable (@escaping @Sendable (API) throws -> URLRequest) -> ClientOutput
  ) throws where Auth == BearerAuth, AuthRouter == StripeAuthRouter {
    @Dependency(\.envVars.stripe.baseUrl) var baseUrl
    @Dependency(\.envVars.stripe.secretKey) var secretKey

    guard let secretKey else {
      throw NSError(
        domain: "StripeAuth",
        code: 1,
        userInfo: [NSLocalizedDescriptionKey: "STRIPE_SECRET_KEY environment variable not set"]
      )
    }

    self = .init(
      baseURL: baseUrl,
      auth: try .init(token: secretKey.rawValue),
      apiRouter: router,
      authRouter: .init(),
      buildClient: buildClient
    )
  }
}

extension Authenticated {
  package static func fromEnvironmentVariables(
    router: APIRouter,
    buildClient:
      @escaping @Sendable (
        _ makeRequest: @escaping @Sendable (_ route: API) throws -> URLRequest
      ) -> ClientOutput
  ) throws -> Self where Auth == BearerAuth, AuthRouter == StripeAuthRouter {
    try .init(
      router: router,
      buildClient: { buildClient($0) }
    )
  }
}

extension Authenticated where APIRouter: TestDependencyKey, APIRouter.Value == APIRouter {
  package init(
    buildClient: @escaping @Sendable () -> ClientOutput
  ) throws where Auth == BearerAuth, AuthRouter == StripeAuthRouter {
    @Dependency(APIRouter.self) var router
    self = try .fromEnvironmentVariables(
      router: router
    ) { _ in buildClient() }
  }
}

extension Authenticated where APIRouter: TestDependencyKey, APIRouter.Value == APIRouter {
  package init(
    _ buildClient:
      @escaping @Sendable (
        _ makeRequest: @escaping @Sendable (_ route: API) throws -> URLRequest
      ) -> ClientOutput
  ) throws where Auth == BearerAuth, AuthRouter == StripeAuthRouter {
    @Dependency(APIRouter.self) var router
    self = try .fromEnvironmentVariables(
      router: router,
      buildClient: buildClient
    )
  }
}

public struct StripeAuthRouter: ParserPrinter, Sendable {

  public init() {}

  public var body: some URLRouting.Router<BearerAuth> {
    Headers {
      Field("Stripe-Version") { "2024-12-18.acacia" }

      Field.form.urlEncoded
    }

    BearerAuth.Router()
  }
}
