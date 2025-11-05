//
//  File.swift
//  swift-stripe
//
//  Created by Coen ten Thije Boonkkamp on 09/01/2025.
//

import Dependencies
import Foundation
import IssueReporting
import Stripe_Balance_Live
import Stripe_Balance_Transactions_Live
import Stripe_Billing_Live
import Stripe_Capital_Live
import Stripe_Charges_Live
import Stripe_Checkout_Live
import Stripe_Climate_Live
import Stripe_Confirmation_Token_Live
import Stripe_Connect_Live
import Stripe_Crypto_Live
import Stripe_Customer_Session_Live
import Stripe_Customers_Live
import Stripe_Disputes_Live
import Stripe_Entitlements_Live
import Stripe_Event_Destinations_Live
import Stripe_Events_Live
import Stripe_File_Links_Live
import Stripe_Files_Live
import Stripe_Financial_Connections_Live
import Stripe_Forwarding_Live
import Stripe_Fraud_Live
import Stripe_Identity_Live
import Stripe_Issuing_Live
import Stripe_Live_Shared
import Stripe_Mandates_Live
import Stripe_Payment_Intents_Live
import Stripe_Payment_Link_Live
import Stripe_Payment_Methods_Live
import Stripe_Payouts_Live
import Stripe_Products_Live
import Stripe_Refunds_Live
import Stripe_Reporting_Live
import Stripe_Setup_Attempts_Live
import Stripe_Setup_Intents_Live
import Stripe_Sigma_Live
import Stripe_Tax_Live
import Stripe_Terminal_Live
import Stripe_Tokens_Live
import Stripe_Treasury_Live
import Stripe_Types
import Stripe_Webhooks_Live

extension Stripe.Client {
    public static func live(
        makeRequest: @escaping @Sendable (_ route: Stripe.API) throws -> URLRequest
    ) -> Self {
        return Self(
            balance: .live { try makeRequest(.balance($0)) },
            balanceTransactions: .live { try makeRequest(.balanceTransactions($0)) },
            charges: .live { try makeRequest(.charges($0)) },
            customers: .live { try makeRequest(.customers($0)) },
            customerSessions: .live { try makeRequest(.customerSessions($0)) },
            disputes: .live { try makeRequest(.disputes($0)) },
            events: .live { try makeRequest(.events($0)) },
            files: .live { try makeRequest(.files($0)) },
            fileLinks: .live { try makeRequest(.fileLinks($0)) },
            mandates: .live { try makeRequest(.mandates($0)) },
            paymentIntents: .live { try makeRequest(.paymentIntents($0)) },
            setupIntents: .live { try makeRequest(.setupIntents($0)) },
            setupAttempts: .live { try makeRequest(.setupAttempts($0)) },
            payouts: .live { try makeRequest(.payouts($0)) },
            refunds: .live { try makeRequest(.refunds($0)) },
            confirmationToken: .live { try makeRequest(.confirmationToken($0)) },
            tokens: .live { try makeRequest(.tokens($0)) },
            paymentMethods: .live { try makeRequest(.paymentMethods($0)) },
            paymentLinks: .live { try makeRequest(.paymentLinks($0)) },
            products: .live { try makeRequest(.products($0)) },
            checkout: .live { try makeRequest(.checkout($0)) },
            billing: .live { try makeRequest(.billing($0)) }
        )
    }
}

extension Stripe {
    public typealias Authenticated = Stripe_Live_Shared.Authenticated<
        Stripe.API,
        Stripe.API.Router,
        Stripe.Client
    >
}

extension Stripe: @retroactive DependencyKey {
    public static var liveValue: Stripe.Authenticated {
        try! Stripe.Authenticated { .live(makeRequest: $0) }
    }
    public static let testValue: Stripe.Authenticated = liveValue
}

extension Stripe.API.Router: @retroactive DependencyKey {
    public static let liveValue: Stripe.API.Router = .init()
}

extension DependencyValues {
    public var stripe: Stripe.Authenticated {
        get { self[Stripe.self] }
        set { self[Stripe.self] = newValue }
    }
}
