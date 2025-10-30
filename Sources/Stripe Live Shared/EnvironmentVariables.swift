//
//  File.swift
//  coenttb-stripe
//
//  Created by Coen ten Thije Boonkkamp on 23/01/2025.
//

import Dependencies
import EnvironmentVariables
import Foundation

extension EnvironmentVariables {

  public struct Stripe: Sendable, Equatable {
    public var baseUrl: URL {
      @Dependency(\.envVars) var envVars
      return envVars["STRIPE_BASE_URL"].flatMap(URL.init(string:)) ?? URL(
        string: "https://api.stripe.com/v1"
      )!
    }

    package var secretKey: ApiKey {
      @Dependency(\.envVars) var envVars
      return envVars["STRIPE_SECRET_KEY"].map(ApiKey.init(rawValue:))!
    }

    public var publishableKey: ApiKey {
      @Dependency(\.envVars) var envVars
      return envVars["STRIPE_PUBLISHABLE_KEY"].map(ApiKey.init(rawValue:))!
    }

    public var webhookSecret: String? {
      @Dependency(\.envVars) var envVars
      return envVars["STRIPE_WEBHOOK_SIGNING_SECRET"]
    }
  }
}

extension EnvironmentVariables {
  public var stripe: Stripe { .init() }
}

extension EnvironmentVariables {
  package var stripeTestMailingList: EmailAddress {
    self["STRIPE_TEST_MAILINGLIST"].map { try! EmailAddress($0) }!
  }

  package var stripeTestRecipient: EmailAddress {
    self["STRIPE_TEST_RECIPIENT"].map { try! EmailAddress($0) }!
  }

  package var stripeFrom: EmailAddress {
    self["STRIPE_FROM_EMAIL"].map { try! EmailAddress($0) }!
  }

  package var stripeTo: EmailAddress {
    self["STRIPE_TO_EMAIL"].map { try! EmailAddress($0) }!
  }
}

extension EnvVars {
  package static var development: Self {
    @Dependency(\.projectRoot) var projectRoot
    return try! .live(
      environmentConfiguration: .projectRoot(projectRoot, environment: "development"),
      requiredKeys: []
    )
  }
}
