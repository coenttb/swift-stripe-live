# swift-stripe-live

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![License](https://img.shields.io/badge/License-AGPL%203.0-blue.svg)](LICENSE.md)
[![Version](https://img.shields.io/badge/version-0.1.0-green.svg)](https://github.com/coenttb/swift-stripe-live/releases)

Production-ready live implementations for Stripe API operations in Swift server applications.

## Overview

`swift-stripe-live` provides complete HTTP client implementations for Stripe's REST API with:

- 🌐 **Live Networking**: Async/await based HTTP client implementations
- 🔐 **Authentication**: Secure API key management and request signing
- ⚡ **High Performance**: Efficient connection pooling and request handling
- 📦 **48 Modules Implemented**: Complete coverage of essential Stripe features
- 🧪 **Testable**: Dependency injection with swift-dependencies
- 🚀 **Production Ready**: Battle-tested in production environments
- 📊 **Comprehensive Coverage**: Payments, billing, subscriptions, and more

## Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/coenttb/swift-stripe-live", from: "0.1.0")
]
```

## Quick Start

### Configuration

Set your Stripe API keys via environment variables:

```bash
export STRIPE_SECRET_KEY=sk_test_...
export STRIPE_PUBLISHABLE_KEY=pk_test_...
```

Or use an `.env` file in your project root.

### Basic Usage

```swift
import StripeLive
import Dependencies

// Use dependency injection
@Dependency(\.stripe.client.customers) var customers
@Dependency(\.stripe.client.paymentIntents) var paymentIntents

// Create a customer
let customer = try await customers.create(
    .init(
        email: "customer@example.com",
        name: "John Doe",
        metadata: ["user_id": "usr_123"]
    )
)

// Create a payment intent
let intent = try await paymentIntents.create(
    .init(
        amount: 2000,
        currency: .usd,
        customer: customer.id,
        metadata: ["order_id": "ord_456"]
    )
)

// Confirm payment
let confirmed = try await paymentIntents.confirm(
    intent.id,
    .init(paymentMethod: "pm_card_visa")
)
```

### Subscription Management

```swift
@Dependency(\.stripe.client.subscriptions) var subscriptions
@Dependency(\.stripe.client.prices) var prices

// Create a subscription
let subscription = try await subscriptions.create(
    .init(
        customer: customer.id,
        items: [
            .init(price: "price_monthly_plan")
        ],
        paymentBehavior: .defaultIncomplete,
        paymentSettings: .init(
            paymentMethodTypes: [.card]
        )
    )
)

// Update subscription
let updated = try await subscriptions.update(
    subscription.id,
    .init(
        items: [
            .init(
                id: subscription.items.data[0].id,
                price: "price_annual_plan"
            )
        ]
    )
)

// Cancel subscription
let canceled = try await subscriptions.cancel(
    subscription.id,
    .init(invoiceNow: true)
)
```

## Implemented Modules

### Core Payment Processing ✅
- Payment Intents, Payment Methods, Setup Intents
- Charges, Refunds, Disputes
- Customer management
- Token handling

### Billing & Subscriptions ✅
- Subscriptions with items and schedules
- Invoices with line items
- Credit notes and adjustments
- Plans, prices, and usage records
- Quotes and test clocks
- Customer portal configuration

### Products & Commerce ✅
- Product catalog
- Dynamic pricing
- Coupons and promotion codes
- Tax rates and shipping rates

### Platform & Connect ✅
- Connected accounts
- Transfers and reversals
- Account links and sessions
- Application fees

### Additional Features ✅
- Balance and transactions
- Events and webhooks
- File uploads
- Payouts
- Terminal for in-person payments
- Tax calculations
- Fraud detection

## Architecture

### Live Client Pattern

Each Stripe resource has a live implementation:

```swift
extension Stripe.Customers.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Stripe.Customers.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.Stripe.self) var handleRequest
        
        return Self(
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Stripe.Customer.self
                )
            },
            retrieve: { id in
                try await handleRequest(
                    for: makeRequest(.retrieve(id: id)),
                    decodingTo: Stripe.Customer.self
                )
            }
            // ... other operations
        )
    }
}
```

### Error Handling

Comprehensive error handling for:
- Network failures
- API errors with detailed messages
- Rate limiting with automatic retry
- Authentication failures
- Validation errors

### Testing

Test against Stripe's test mode:

```swift
import Testing
import StripeLive
import Dependencies

@Test
func testPaymentFlow() async throws {
    // Use test API keys
    await withDependencies {
        $0.stripe.secretKey = "sk_test_..."
    } operation: {
        let customer = try await customers.create(
            .init(email: "test@example.com")
        )
        
        #expect(customer.email == "test@example.com")
    }
}
```

## Dependencies

Built on robust foundations:
- [swift-stripe-types](https://github.com/coenttb/swift-stripe-types): Type definitions (Apache 2.0)
- [swift-server-foundation](https://github.com/coenttb/swift-server-foundation): Server utilities
- [swift-dependencies](https://github.com/pointfreeco/swift-dependencies): Dependency injection

## Production Use

This package powers production Stripe integrations including:
- E-commerce platforms
- SaaS subscription services
- Marketplace applications
- Payment processing systems

## Related Packages

- [swift-stripe-types](https://github.com/coenttb/swift-stripe-types): Core types (Apache 2.0)
- [swift-stripe](https://github.com/coenttb/swift-stripe): High-level client wrapper
- [coenttb-com-server](https://github.com/coenttb/coenttb-com-server): Production example

## Requirements

- Swift 6.0+
- macOS 14+ / iOS 17+ / Linux
- Stripe account with API keys

## License

This package is licensed under the AGPL 3.0 License. See [LICENSE.md](LICENSE.md) for details.

For commercial licensing options, please contact the maintainer.

## Support

For issues, questions, or contributions, please visit the [GitHub repository](https://github.com/coenttb/swift-stripe-live).