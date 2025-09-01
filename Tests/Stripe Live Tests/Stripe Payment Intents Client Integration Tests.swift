//
//  File.swift
//  coenttb-stripe
//
//  Created by Coen ten Thije Boonkkamp on 04/01/2025.
//

import Stripe_Payment_Intents_Live
import Stripe_Customers_Live
import Dependencies
import DependenciesTestSupport
import EnvironmentVariables
import Foundation
import IssueReporting
import Stripe_Live_Shared
import Testing

@Suite(
    "Payment Intents Client Tests",
    .dependency(\.projectRoot, .stripe),
    .dependency(\.envVars, .development),
    .dependency(\.date, .init(Date.init)),
    .dependency(\.continuousClock, ContinuousClock())
)
struct PaymentIntentsClientTests {
    @Test("Should successfully create a payment intent")
    func testCreatePaymentIntent() async throws {
        @Dependency(Stripe.PaymentIntents.self) var client
        @Dependency(Stripe.Customers.self) var customersClient

        // Create test customer
        let customer = try await customersClient.client.create(
            Stripe.Customers.Create.Request(
                description: "Test payment intent customer",
                email: "payment.intent.test@example.com",
                name: "Payment Intent Test Customer"
            )
        )

        let response = try await client.client.create(
            Stripe.PaymentIntents.Create.Request(
                amount: 2000,
                currency: Stripe.Currency.usd,
                automaticPaymentMethods: nil,
                confirm: false,
                customer: customer.id,
                description: "Test payment intent",
                metadata: ["order_id": "test_order_1"],
                paymentMethod: nil,
                receiptEmail: "test@example.com"
            )
        )

        #expect(response.amount == 2000)
        #expect(response.currency == Stripe.Currency.usd)
        #expect(response.description == "Test payment intent")
        #expect(response.metadata?["order_id"] == "test_order_1")
        #expect(response.receiptEmail == "test@example.com")
        #expect(!(response.livemode == true))
        #expect(response.status != Stripe.PaymentIntents.PaymentIntent.Status.succeeded)
        
        // Cleanup
        _ = try await customersClient.client.delete(customer.id)
    }

    @Test("Should successfully retrieve a payment intent")
    func testRetrievePaymentIntent() async throws {
        @Dependency(Stripe.PaymentIntents.self) var client
        @Dependency(Stripe.Customers.self) var customersClient

        // Create test customer
        let customer = try await customersClient.client.create(
            Stripe.Customers.Create.Request(
                description: "Test retrieve payment intent customer",
                email: "retrieve.payment.intent.test@example.com",
                name: "Retrieve Payment Intent Test Customer"
            )
        )

        // First create a payment intent
        let created = try await client.client.create(
            Stripe.PaymentIntents.Create.Request(
                amount: 2000,
                currency: Stripe.Currency.usd,
                customer: customer.id,
                description: "Test retrieve payment intent"
            )
        )

        let retrieved = try await client.client.retrieve(created.id)

        #expect(retrieved.id == created.id)
        #expect(retrieved.amount == created.amount)
        #expect(retrieved.currency == created.currency)
        #expect(retrieved.description == created.description)
        #expect(!(retrieved.livemode == true))
        
        // Cleanup
        _ = try await customersClient.client.delete(customer.id)
    }

    @Test("Should successfully update a payment intent")
    func testUpdatePaymentIntent() async throws {
        @Dependency(Stripe.PaymentIntents.self) var client
        @Dependency(Stripe.Customers.self) var customersClient

        // Create test customer
        let customer = try await customersClient.client.create(
            Stripe.Customers.Create.Request(
                description: "Test update payment intent customer",
                email: "update.payment.intent.test@example.com",
                name: "Update Payment Intent Test Customer"
            )
        )

        // First create a payment intent
        let created = try await client.client.create(
            Stripe.PaymentIntents.Create.Request(
                amount: 2000,
                currency: Stripe.Currency.usd,
                customer: customer.id,
                description: "Original description"
            )
        )

        let updated = try await client.client.update(
            created.id,
            .init(
                amount: 3000,
                description: "Updated description",
                metadata: ["updated": "true"]
            )
        )

        #expect(updated.id == created.id)
        #expect(updated.amount == 3000)
        #expect(updated.description == "Updated description")
        #expect(updated.metadata?["updated"] == "true")
        
        // Cleanup
        _ = try await customersClient.client.delete(customer.id)
    }

    @Test("Should successfully list payment intents")
    func testListPaymentIntents() async throws {
        @Dependency(Stripe.PaymentIntents.self) var client
        @Dependency(Stripe.Customers.self) var customersClient

        // Create test customer and payment intents
        let customer = try await customersClient.client.create(
            Stripe.Customers.Create.Request(
                description: "Test list payment intent customer",
                email: "list.payment.intent.test@example.com",
                name: "List Payment Intent Test Customer"
            )
        )
        
        // Create a few payment intents
        for i in 1...3 {
            _ = try await client.client.create(
                .init(
                    amount: 1000 * i,
                    currency: Stripe.Currency.usd,
                    customer: customer.id,
                    description: "Test list payment intent \(i)"
                )
            )
        }

        let response = try await client.client.list(
            .init(
                customer: customer.id,
                limit: 3
            )
        )

        #expect(response.object == "list")
        #expect(!response.data.isEmpty)
        if !response.data.isEmpty {
            #expect(response.data[0].object == "payment_intent")
            #expect(response.data[0].customer == customer.id)
        }
        
        // Cleanup
        _ = try await customersClient.client.delete(customer.id)
    }

    @Test("Should successfully cancel a payment intent")
    func testCancelPaymentIntent() async throws {
        @Dependency(Stripe.PaymentIntents.self) var client
        @Dependency(Stripe.Customers.self) var customersClient

        // Create test customer
        let customer = try await customersClient.client.create(
            Stripe.Customers.Create.Request(
                description: "Test cancel payment intent customer",
                email: "cancel.payment.intent.test@example.com",
                name: "Cancel Payment Intent Test Customer"
            )
        )

        // First create a payment intent
        let created = try await client.client.create(
            Stripe.PaymentIntents.Create.Request(
                amount: 2000,
                currency: Stripe.Currency.usd,
                customer: customer.id
            )
        )

        let canceled = try await client.client.cancel(
            created.id,
            .init(
                cancellationReason: .requestedByCustomer
            )
        )

        #expect(canceled.id == created.id)
        #expect(canceled.status == Stripe.PaymentIntents.PaymentIntent.Status.canceled)
        #expect(canceled.cancellationReason == Stripe.PaymentIntents.PaymentIntent.Cancellation.Reason.requestedByCustomer)
        
        // Cleanup
        _ = try await customersClient.client.delete(customer.id)
    }

    @Test("Should successfully confirm a payment intent")
    func testConfirmPaymentIntent() async throws {
        @Dependency(Stripe.PaymentIntents.self) var client
        @Dependency(Stripe.Customers.self) var customersClient

        // Create test customer
        let customer = try await customersClient.client.create(
            Stripe.Customers.Create.Request(
                description: "Test confirm payment intent customer",
                email: "confirm.payment.intent.test@example.com",
                name: "Confirm Payment Intent Test Customer"
            )
        )

        // First create a payment intent with a payment method
        let created = try await client.client.create(
            Stripe.PaymentIntents.Create.Request(
                amount: 2000,
                currency: Stripe.Currency.usd,
                customer: customer.id,
                paymentMethod: "pm_card_visa" // Using test payment method
            )
        )

        let confirmed = try await client.client.confirm(
            created.id,
            Stripe.PaymentIntents.Confirm.Request(
                paymentMethod: "pm_card_visa",
                returnUrl: "https://example.com/return"
            )
        )

        #expect(confirmed.id == created.id)
        #expect(confirmed.paymentMethod != nil)
        #expect(confirmed.status == Stripe.PaymentIntents.PaymentIntent.Status.succeeded || confirmed.status == Stripe.PaymentIntents.PaymentIntent.Status.requiresAction)
        
        // Cleanup
        _ = try await customersClient.client.delete(customer.id)
    }

    @Test("Should successfully capture a payment intent")
    func testCapturePaymentIntent() async throws {
        @Dependency(Stripe.PaymentIntents.self) var client
        @Dependency(Stripe.Customers.self) var customersClient

        // Create test customer
        let customer = try await customersClient.client.create(
            Stripe.Customers.Create.Request(
                description: "Test capture payment intent customer",
                email: "capture.payment.intent.test@example.com",
                name: "Capture Payment Intent Test Customer"
            )
        )

        // First create a payment intent with manual capture
        let created = try await client.client.create(
            Stripe.PaymentIntents.Create.Request(
                amount: 1500,
                currency: .eur,
                automaticPaymentMethods: .init(enabled: false),
                customer: customer.id,
                paymentMethod: "pm_card_visa",
                captureMethod: .manual,
                paymentMethodTypes: ["card"]
            )
        )

        // Confirm the payment first
        let confirmed = try await client.client.confirm(
            created.id,
            Stripe.PaymentIntents.Confirm.Request(
                paymentMethod: "pm_card_visa",
                returnUrl: "https://example.com/return"
            )
        )
        #expect(confirmed.status == Stripe.PaymentIntents.PaymentIntent.Status.requiresCapture || confirmed.status == Stripe.PaymentIntents.PaymentIntent.Status.succeeded)

        // Now capture the confirmed payment if it requires capture
        if confirmed.status == Stripe.PaymentIntents.PaymentIntent.Status.requiresCapture {
            let captured = try await client.client.capture(
                confirmed.id,
                .init(
                    amountToCapture: 1500
                )
            )

            #expect(captured.id == created.id)
            #expect(captured.amountReceived == 1500)
        }
        
        // Cleanup
        _ = try await customersClient.client.delete(customer.id)
    }

    @Test("Should partially capture a payment intent")
    func testPartialCapturePaymentIntent() async throws {
        @Dependency(Stripe.PaymentIntents.self) var client
        @Dependency(Stripe.Customers.self) var customersClient

        // Create test customer
        let customer = try await customersClient.client.create(
            Stripe.Customers.Create.Request(
                description: "Test partial capture payment intent customer",
                email: "partial.capture.payment.intent.test@example.com",
                name: "Partial Capture Payment Intent Test Customer"
            )
        )

        // 1. Create a PaymentIntent with manual capture for €2000
        let created = try await client.client.create(
            Stripe.PaymentIntents.Create.Request(
                amount: 2000,
                currency: .eur,
                automaticPaymentMethods: .init(enabled: false),
                customer: customer.id,
                paymentMethod: "pm_card_visa",
                captureMethod: .manual,
                paymentMethodTypes: ["card"]
            )
        )

        // 2. Confirm the PaymentIntent
        let confirmed = try await client.client.confirm(
            created.id,
            Stripe.PaymentIntents.Confirm.Request(
                paymentMethod: "pm_card_visa",
                returnUrl: "https://example.com/return"
            )
        )
        #expect(confirmed.status == Stripe.PaymentIntents.PaymentIntent.Status.requiresCapture || confirmed.status == Stripe.PaymentIntents.PaymentIntent.Status.succeeded)

        // 3. Partially capture the PaymentIntent by specifying a lower amount (e.g., €1500)
        if confirmed.status == Stripe.PaymentIntents.PaymentIntent.Status.requiresCapture {
            let partiallyCaptured = try await client.client.capture(
                confirmed.id,
                .init(
                    amountToCapture: 1500
                )
            )

            // 4. Validate partial capture
            #expect(partiallyCaptured.id == created.id)
            #expect(partiallyCaptured.amountReceived == 1500)
        }
        
        // Cleanup
        _ = try await customersClient.client.delete(customer.id)
    }

    @Test("Should successfully search payment intents")
    func testSearchPaymentIntents() async throws {
        @Dependency(Stripe.PaymentIntents.self) var client
        @Dependency(Stripe.Customers.self) var customersClient

        // Create test customer
        let customer = try await customersClient.client.create(
            Stripe.Customers.Create.Request(
                description: "Test search payment intent customer",
                email: "search.payment.intent.test@example.com",
                name: "Search Payment Intent Test Customer"
            )
        )

        // Create a payment intent with unique metadata
        let uniqueId = UUID().uuidString
        _ = try await client.client.create(
            .init(
                amount: 2000,
                currency: Stripe.Currency.usd,
                customer: customer.id,
                metadata: ["search_test_id": uniqueId]
            )
        )

        let response = try await client.client.search(
            .init(
                query: "metadata['search_test_id']:'\(uniqueId)'",
                limit: 3
            )
        )

        #expect(response.object == "search_result")
        if !response.data.isEmpty {
            #expect(response.data[0].metadata?["search_test_id"] == uniqueId)
        }
        
        // Cleanup
        _ = try await customersClient.client.delete(customer.id)
    }

    @Test("Should handle payment intent workflow")
    func testPaymentIntentWorkflow() async throws {
        @Dependency(Stripe.PaymentIntents.self) var client
        @Dependency(Stripe.Customers.self) var customersClient

        // Create test customer
        let customer = try await customersClient.client.create(
            Stripe.Customers.Create.Request(
                description: "Test workflow payment intent customer",
                email: "workflow.payment.intent.test@example.com",
                name: "Workflow Payment Intent Test Customer"
            )
        )

        /*
         1. Create a PaymentIntent with automatic payment methods.
         Stripe may immediately set status to "requires_payment_method"
         or "requires_confirmation," depending on how it's configured.
         */
        let created = try await client.client.create(
            Stripe.PaymentIntents.Create.Request(
                amount: 2000,
                currency: Stripe.Currency.usd,
                automaticPaymentMethods: .init(enabled: true),
                customer: customer.id,
                description: "Complete workflow test"
            )
        )

        /*
         2. Since 'pm_card_visa' is a test PaymentMethod "placeholder",
         Stripe will replace it with a real PaymentMethod ID when updated/confirmed.
         We only verify that 'paymentMethod' is set, not that it equals "pm_card_visa".
         */
        let updated = try await client.client.update(
            created.id,
            .init(
                paymentMethod: "pm_card_visa"
            )
        )

        #expect(updated.paymentMethod != nil)

        /*
         3. Confirm the PaymentIntent, including a returnUrl because automaticPaymentMethods
         can enable redirect-based payment methods in your Dashboard.
         */
        let confirmed = try await client.client.confirm(
            created.id,
            Stripe.PaymentIntents.Confirm.Request(
                paymentMethod: "pm_card_visa",
                returnUrl: "https://example.com/return"
            )
        )

        #expect(confirmed.status != Stripe.PaymentIntents.PaymentIntent.Status.requiresPaymentMethod)

        /*
         4. If the payment still isn't succeeded or canceled, we cancel it.
         This covers scenarios where an additional step might be needed.
         */
        if confirmed.status != Stripe.PaymentIntents.PaymentIntent.Status.succeeded && confirmed.status != Stripe.PaymentIntents.PaymentIntent.Status.canceled {
            let canceled = try await client.client.cancel(
                confirmed.id,
                .init(
                    cancellationReason: .requestedByCustomer
                )
            )
            #expect(canceled.status == Stripe.PaymentIntents.PaymentIntent.Status.canceled)
        }
        
        // Cleanup
        _ = try await customersClient.client.delete(customer.id)
    }
}
