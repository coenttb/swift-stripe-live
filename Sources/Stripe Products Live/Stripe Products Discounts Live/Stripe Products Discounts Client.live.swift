import Dependencies
import Stripe_Live_Shared
import Stripe_Products_Types
import Stripe_Types_Models

extension Stripe.Products.Discounts.Client {
  public static func live(
    makeRequest: @escaping @Sendable (_ route: Stripe.Products.Discounts.API) throws -> URLRequest
  ) -> Self {
    @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

    return Self(
      deleteCustomerDiscount: { customerId in
        try await handleRequest(
          for: makeRequest(.deleteCustomerDiscount(customerId: customerId)),
          decodingTo: DeletedObject<Stripe.Products.Discount>.self
        )
      },
      deleteSubscriptionDiscount: { subscriptionId in
        try await handleRequest(
          for: makeRequest(.deleteSubscriptionDiscount(subscriptionId: subscriptionId)),
          decodingTo: DeletedObject<Stripe.Products.Discount>.self
        )
      }
    )
  }
}

extension Stripe.Products.Discounts {
  public typealias Authenticated = Stripe_Live_Shared.Authenticated<
    Stripe.Products.Discounts.API,
    Stripe.Products.Discounts.API.Router,
    Stripe.Products.Discounts.Client
  >
}

extension Stripe.Products.Discounts: @retroactive DependencyKey {
  public static var liveValue: Stripe.Products.Discounts.Authenticated {
    try! Stripe.Products.Discounts.Authenticated { .live(makeRequest: $0) }
  }
  public static let testValue: Stripe.Products.Discounts.Authenticated = liveValue
}

extension Stripe.Products.Discounts.API.Router: @retroactive DependencyKey {
  public static let liveValue: Self = .init()
  public static let testValue: Self = .init()
}
