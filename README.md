# swift-stripe-live

[![CI](https://github.com/coenttb/swift-stripe-live/workflows/CI/badge.svg)](https://github.com/coenttb/swift-stripe-live/actions/workflows/ci.yml)
![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Live HTTP client implementations for Stripe's REST API in Swift server applications.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Quick Start](#quick-start)
  - [Configuration](#configuration)
  - [Basic Usage](#basic-usage)
  - [Subscription Management](#subscription-management)
- [Implemented Modules](#implemented-modules)
- [Architecture](#architecture)
  - [Live Client Implementation Pattern](#live-client-implementation-pattern)
  - [Error Handling](#error-handling)
  - [Testing](#testing)
- [Dependencies](#dependencies)
- [Related Packages](#related-packages)
- [Requirements](#requirements)
- [License](#license)
- [Contributing](#contributing)

## Overview

`swift-stripe-live` provides HTTP client implementations for Stripe's REST API, built on async/await with dependency injection for testability. This package implements the client protocols defined in [swift-stripe-types](https://github.com/coenttb/swift-stripe-types) to make actual network requests to Stripe's servers.

## Features

- **Async/await networking**: Modern Swift concurrency for all HTTP requests
- **Dependency injection**: Built with swift-dependencies for testability
- **Authentication handling**: Automatic API key management and request signing
- **Comprehensive coverage**: 48+ modules covering core payments, billing, subscriptions, Connect, Issuing, Terminal, and more
- **Type-safe clients**: Implements protocols from swift-stripe-types for compile-time safety
- **Production tested**: Powers live Stripe integrations in production applications

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
import Stripe_Customers_Live
import Stripe_Payment_Intents_Live
import Dependencies

// Access clients via dependency injection
@Dependency(Stripe.Customers.self) var customersClient
@Dependency(Stripe.PaymentIntents.self) var paymentIntentsClient

// Create a customer
let customer = try await customersClient.client.create(
    Stripe.Customers.Create.Request(
        email: "customer@example.com",
        metadata: ["user_id": "usr_123"],
        name: "John Doe"
    )
)

// Create a payment intent
let intent = try await paymentIntentsClient.client.create(
    Stripe.PaymentIntents.Create.Request(
        amount: 2000,
        currency: .usd,
        customer: customer.id,
        metadata: ["order_id": "ord_456"]
    )
)

// Confirm payment
let confirmed = try await paymentIntentsClient.client.confirm(
    intent.id,
    Stripe.PaymentIntents.Confirm.Request(
        paymentMethod: "pm_card_visa"
    )
)
```

### Subscription Management

```swift
import Stripe_Billing_Live
import Dependencies

@Dependency(Stripe.Billing.Subscriptions.self) var subscriptionsClient

// Create a subscription
let subscription = try await subscriptionsClient.client.create(
    Stripe.Billing.Subscriptions.Create.Request(
        customer: customer.id,
        items: [
            .init(price: "price_monthly_plan", quantity: 1)
        ],
        paymentBehavior: .defaultIncomplete
    )
)

// Update subscription metadata
let updated = try await subscriptionsClient.client.update(
    subscription.id,
    Stripe.Billing.Subscriptions.Update.Request(
        metadata: ["tier": "premium"]
    )
)

// Cancel subscription
let canceled = try await subscriptionsClient.client.cancel(
    subscription.id,
    Stripe.Billing.Subscriptions.Cancel.Request(invoiceNow: true)
)
```

## Implemented Modules

The package provides live implementations for 48+ Stripe API modules across these categories:

### Core Payment Processing
- Payment Intents, Payment Methods, Setup Intents
- Charges, Refunds, Disputes
- Customer management
- Token and confirmation token handling

### Billing & Subscriptions
- Subscriptions with items and schedules
- Invoices with line items
- Credit notes and adjustments
- Plans, prices, and usage records
- Quotes and test clocks
- Meters and meter events

### Products & Pricing
- Product catalog management
- Price configuration
- Coupons and promotion codes
- Tax codes and rates

### Connect Platform
- Connected accounts
- Transfers and reversals
- Account links and sessions
- Application fees and refunds
- External accounts

### Additional Modules
- Balance and balance transactions
- Events and event destinations
- File uploads and links
- Payouts and mandates
- Terminal (in-person payments)
- Tax calculations and registrations
- Issuing (cards, cardholders, authorizations)
- Treasury (financial accounts)
- Identity verification
- Fraud detection
- Climate orders
- Entitlements
- Sigma scheduled queries
- Financial connections
- Crypto onramp
- Webhooks
- Forwarding requests

## Architecture

### Live Client Implementation Pattern

Each Stripe API module follows this implementation pattern:

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
            // ... other endpoints
        )
    }
}
```

The `Authenticated` wrapper type handles API key injection and base URL configuration from environment variables.

### Error Handling

The package handles:
- Network failures and timeouts
- Stripe API errors with detailed error messages
- Rate limiting (requires manual retry logic)
- Authentication failures
- Request validation errors

### Testing

Use Swift Testing framework with dependency injection:

```swift
import Testing
import Stripe_Customers_Live
import Dependencies
import EnvironmentVariables

@Suite(
    .dependency(\.envVars, .development)
)
struct CustomerTests {
    @Test
    func testCustomerCreation() async throws {
        @Dependency(Stripe.Customers.self) var client

        let customer = try await client.client.create(
            Stripe.Customers.Create.Request(
                email: "test@example.com",
                name: "Test Customer"
            )
        )

        #expect(customer.email == "test@example.com")

        // Cleanup
        _ = try await client.client.delete(customer.id)
    }
}
```

## Dependencies

- [swift-stripe-types](https://github.com/coenttb/swift-stripe-types): Core type definitions and client protocols
- [swift-server-foundation](https://github.com/coenttb/swift-server-foundation): Server utilities and HTTP handling
- [swift-dependencies](https://github.com/pointfreeco/swift-dependencies): Dependency injection framework
- [swift-authenticating](https://github.com/coenttb/swift-authenticating): Authentication utilities
- [swift-environment-variables](https://github.com/coenttb/swift-environment-variables): Environment variable management

## Related Packages

- [swift-stripe-types](https://github.com/coenttb/swift-stripe-types): A Swift package with foundational types for Stripe
- [swift-stripe](https://github.com/coenttb/swift-stripe): The Swift library for the Stripe API

## Requirements

- Swift 6.0+
- macOS 14+ / iOS 17+ / Linux
- Stripe account with API keys (test mode recommended for development)

## License

This package is licensed under the AGPL 3.0 License. See [LICENSE](LICENSE) for details.

For commercial licensing options, please contact the maintainer.

## Contributing

Contributions are welcome. Please open an issue or pull request on [GitHub](https://github.com/coenttb/swift-stripe-live).