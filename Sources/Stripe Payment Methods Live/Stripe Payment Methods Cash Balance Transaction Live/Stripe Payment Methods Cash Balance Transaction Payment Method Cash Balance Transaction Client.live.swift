extension Stripe.PaymentMethods.PaymentMethods.Client {
  public static func live(
    makeRequest:
      @escaping @Sendable (_ route: Stripe.PaymentMethods.PaymentMethods.API) throws -> URLRequest
  ) -> Self {
    @Dependency(URLRequest.Handler.Stripe.self) var handleRequest

    return Self(
      create: { request in
        try await handleRequest(
          for: makeRequest(.create(request: request)),
          decodingTo: Stripe.PaymentMethods.PaymentMethod.self
        )
      },
      retrieve: { id in
        try await handleRequest(
          for: makeRequest(.retrieve(id: id)),
          decodingTo: Stripe.PaymentMethods.PaymentMethod.self
        )
      },
      retrieveCustomer: { customerId, paymentMethodId in
        try await handleRequest(
          for: makeRequest(
            .retrieveCustomer(customerId: customerId, paymentMethodId: paymentMethodId)
          ),
          decodingTo: Stripe.PaymentMethods.PaymentMethod.self
        )
      },
      update: { id, request in
        try await handleRequest(
          for: makeRequest(.update(id: id, request: request)),
          decodingTo: Stripe.PaymentMethods.PaymentMethod.self
        )
      },
      list: { request in
        try await handleRequest(
          for: makeRequest(.list(request: request)),
          decodingTo: Stripe.PaymentMethods.PaymentMethods.List.Response.self
        )
      },
      listCustomer: { customerId, request in
        try await handleRequest(
          for: makeRequest(.listCustomer(customerId: customerId, request: request)),
          decodingTo: Stripe.PaymentMethods.PaymentMethods.List.Customer.Response.self
        )
      },
      attach: { id, request in
        try await handleRequest(
          for: makeRequest(.attach(id: id, request: request)),
          decodingTo: Stripe.PaymentMethods.PaymentMethod.self
        )
      },

      detach: { id in
        try await handleRequest(
          for: makeRequest(.detach(id: id)),
          decodingTo: Stripe.PaymentMethods.PaymentMethod.self
        )
      }
    )
  }
}

extension Stripe.PaymentMethods.PaymentMethods {
  public typealias Authenticated = Stripe_Live_Shared.Authenticated<
    Stripe.PaymentMethods.PaymentMethods.API,
    Stripe.PaymentMethods.PaymentMethods.API.Router,
    Stripe.PaymentMethods.PaymentMethods.Client
  >
}

extension Stripe.PaymentMethods.PaymentMethods: @retroactive DependencyKey {
  public static var liveValue: Stripe.PaymentMethods.Authenticated {
    try! Stripe.PaymentMethods.Authenticated { .live(makeRequest: $0) }
  }
  public static let testValue: Stripe.PaymentMethods.Authenticated = liveValue
}

extension Stripe.PaymentMethods.PaymentMethods.API.Router: @retroactive DependencyKey {
  public static let liveValue: Self = .init()
  public static let testValue: Self = .init()
}
