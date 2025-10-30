//
//  ReadmeVerificationTests.swift
//  swift-stripe-live
//
//  Verifies that all code examples in README.md compile and work correctly.
//

import Stripe_Billing_Live
import Stripe_Customers_Live
import Stripe_Payment_Intents_Live
import Dependencies
import DependenciesTestSupport
import EnvironmentVariables
import Foundation
import IssueReporting
import Stripe_Live_Shared
import Testing

@Suite(
    "README Verification Tests",
    .dependency(\.projectRoot, .stripe),
    .dependency(\.envVars, .development),
    .dependency(\.date, .init(Date.init)),
    .dependency(\.continuousClock, ContinuousClock())
)
struct ReadmeVerificationTests {

    // MARK: - Quick Start Examples

    @Test("README Example: Basic Usage - Customer Creation (Lines 46-62)")
    func testBasicUsageCustomerCreation() async throws {
        // From README lines 46-62
        @Dependency(Stripe.Customers.self) var customersClient

        let customer = try await customersClient.client.create(
            Stripe.Customers.Create.Request(
                email: "customer@example.com",
                name: "John Doe",
                metadata: ["user_id": "usr_123"]
            )
        )

        #expect(customer.email == "customer@example.com")
        #expect(customer.name == "John Doe")
        #expect(customer.metadata?["user_id"] == "usr_123")

        // Cleanup
        _ = try await customersClient.client.delete(customer.id)
    }

    @Test("README Example: Basic Usage - Payment Intent Creation (Lines 64-72)")
    func testBasicUsagePaymentIntentCreation() async throws {
        // From README lines 64-72
        @Dependency(Stripe.Customers.self) var customersClient
        @Dependency(Stripe.PaymentIntents.self) var paymentIntentsClient

        // Create customer first
        let customer = try await customersClient.client.create(
            Stripe.Customers.Create.Request(
                email: "customer@example.com",
                name: "John Doe"
            )
        )

        let intent = try await paymentIntentsClient.client.create(
            Stripe.PaymentIntents.Create.Request(
                amount: 2000,
                currency: .usd,
                customer: customer.id,
                metadata: ["order_id": "ord_456"]
            )
        )

        #expect(intent.amount == 2000)
        #expect(intent.currency == .usd)
        #expect(intent.customer == customer.id)
        #expect(intent.metadata?["order_id"] == "ord_456")

        // Cleanup
        _ = try await paymentIntentsClient.client.cancel(intent.id, .init())
        _ = try await customersClient.client.delete(customer.id)
    }

    @Test("README Example: Subscription Management - Create Subscription (Lines 92-100)")
    func testSubscriptionCreation() async throws {
        // From README lines 92-100
        @Dependency(Stripe.Billing.Subscriptions.self) var subscriptionsClient
        @Dependency(Stripe.Customers.self) var customersClient
        @Dependency(Stripe.Products.Products.self) var productsClient
        @Dependency(Stripe.Products.Prices.self) var pricesClient

        // Setup: Create customer, product, and price
        let customer = try await customersClient.client.create(
            Stripe.Customers.Create.Request(
                email: "subscription@example.com",
                name: "Subscription Test"
            )
        )

        let product = try await productsClient.client.create(
            .init(name: "Monthly Plan", description: "Test monthly plan")
        )

        let price = try await pricesClient.client.create(
            .init(
                currency: .usd,
                product: product.id,
                recurring: .init(interval: .month, intervalCount: 1),
                unitAmount: 1000
            )
        )

        // Test subscription creation
        let subscription = try await subscriptionsClient.client.create(
            Stripe.Billing.Subscriptions.Create.Request(
                customer: customer.id,
                items: [
                    .init(price: price.id, quantity: 1)
                ],
                paymentBehavior: .defaultIncomplete
            )
        )

        #expect(subscription.customer == customer.id)
        #expect(subscription.items?.data?.first?.price?.id == price.id)

        // Cleanup
        _ = try await subscriptionsClient.client.cancel(subscription.id, .init())
        _ = try await customersClient.client.delete(customer.id)
        _ = try await productsClient.client.update(product.id, .init(active: false))
    }

    @Test("README Example: Subscription Management - Update Subscription (Lines 102-113)")
    func testSubscriptionUpdate() async throws {
        // From README lines 102-113
        @Dependency(Stripe.Billing.Subscriptions.self) var subscriptionsClient
        @Dependency(Stripe.Customers.self) var customersClient
        @Dependency(Stripe.Products.Products.self) var productsClient
        @Dependency(Stripe.Products.Prices.self) var pricesClient

        // Setup: Create customer, product, prices, and subscription
        let customer = try await customersClient.client.create(
            Stripe.Customers.Create.Request(
                email: "update@example.com",
                name: "Update Test"
            )
        )

        let product = try await productsClient.client.create(
            .init(name: "Test Plan", description: "Test plan")
        )

        let monthlyPrice = try await pricesClient.client.create(
            .init(
                currency: .usd,
                product: product.id,
                recurring: .init(interval: .month, intervalCount: 1),
                unitAmount: 1000
            )
        )

        let annualPrice = try await pricesClient.client.create(
            .init(
                currency: .usd,
                product: product.id,
                recurring: .init(interval: .year, intervalCount: 1),
                unitAmount: 10000
            )
        )

        let subscription = try await subscriptionsClient.client.create(
            Stripe.Billing.Subscriptions.Create.Request(
                customer: customer.id,
                items: [.init(price: monthlyPrice.id, quantity: 1)],
                paymentBehavior: .defaultIncomplete
            )
        )

        // Test subscription update
        let updated = try await subscriptionsClient.client.update(
            subscription.id,
            Stripe.Billing.Subscriptions.Update.Request(
                items: [
                    .init(
                        id: subscription.items?.data?.first?.id,
                        price: annualPrice.id
                    )
                ]
            )
        )

        #expect(updated.id == subscription.id)
        #expect(updated.items?.data?.first?.price?.id == annualPrice.id)

        // Cleanup
        _ = try await subscriptionsClient.client.cancel(updated.id, .init())
        _ = try await customersClient.client.delete(customer.id)
        _ = try await productsClient.client.update(product.id, .init(active: false))
    }

    @Test("README Example: Subscription Management - Cancel Subscription (Lines 115-119)")
    func testSubscriptionCancellation() async throws {
        // From README lines 115-119
        @Dependency(Stripe.Billing.Subscriptions.self) var subscriptionsClient
        @Dependency(Stripe.Customers.self) var customersClient
        @Dependency(Stripe.Products.Products.self) var productsClient
        @Dependency(Stripe.Products.Prices.self) var pricesClient

        // Setup: Create customer, product, price, and subscription
        let customer = try await customersClient.client.create(
            Stripe.Customers.Create.Request(
                email: "cancel@example.com",
                name: "Cancel Test"
            )
        )

        let product = try await productsClient.client.create(
            .init(name: "Cancel Plan", description: "Test cancel plan")
        )

        let price = try await pricesClient.client.create(
            .init(
                currency: .usd,
                product: product.id,
                recurring: .init(interval: .month, intervalCount: 1),
                unitAmount: 1000
            )
        )

        let subscription = try await subscriptionsClient.client.create(
            Stripe.Billing.Subscriptions.Create.Request(
                customer: customer.id,
                items: [.init(price: price.id, quantity: 1)],
                paymentBehavior: .defaultIncomplete
            )
        )

        // Test subscription cancellation
        let canceled = try await subscriptionsClient.client.cancel(
            subscription.id,
            Stripe.Billing.Subscriptions.Cancel.Request(invoiceNow: true)
        )

        #expect(canceled.id == subscription.id)
        #expect(canceled.status == .canceled)

        // Cleanup
        _ = try await customersClient.client.delete(customer.id)
        _ = try await productsClient.client.update(product.id, .init(active: false))
    }

    // MARK: - Architecture Examples

    @Test("README Example: Live Client Implementation Pattern (Lines 179-201)")
    func testLiveClientImplementationPattern() async throws {
        // From README lines 179-201
        // This test verifies the implementation pattern compiles
        @Dependency(Stripe.Customers.self) var client

        // Verify we can use the client
        let customer = try await client.client.create(
            Stripe.Customers.Create.Request(
                email: "pattern@example.com",
                name: "Pattern Test"
            )
        )

        #expect(customer.email == "pattern@example.com")

        // Verify retrieve works
        let retrieved = try await client.client.retrieve(customer.id)
        #expect(retrieved.id == customer.id)

        // Cleanup
        _ = try await client.client.delete(customer.id)
    }

    // MARK: - Testing Examples

    @Test("README Example: Testing with Dependencies (Lines 220-245)")
    func testTestingExample() async throws {
        // From README lines 220-245
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
