// swift-tools-version:6.0

import Foundation
import PackageDescription

extension String {
    static let stripeLive: Self = "Stripe Live"
    static let stripeBalanceLive: Self = "Stripe Balance Live"
    static let stripeBalanceTransactionsLive: Self = "Stripe Balance Transactions Live"
    static let stripeChargesLive: Self = "Stripe Charges Live"
    static let stripeCustomersLive: Self = "Stripe Customers Live"
    static let stripeCustomerSessionLive: Self = "Stripe Customer Session Live"
    static let stripeDisputesLive: Self = "Stripe Disputes Live"
    static let stripeEventsLive: Self = "Stripe Events Live"
    static let stripeEventDestinationsLive: Self = "Stripe Event Destinations Live"
    static let stripeFilesLive: Self = "Stripe Files Live"
    static let stripeFileLinksLive: Self = "Stripe File Links Live"
    static let stripeMandatesLive: Self = "Stripe Mandates Live"
    static let stripePaymentIntentsLive: Self = "Stripe Payment Intents Live"
    static let stripeSetupIntentsLive: Self = "Stripe Setup Intents Live"
    static let stripeSetupAttemptsLive: Self = "Stripe Setup Attempts Live"
    static let stripePayoutsLive: Self = "Stripe Payouts Live"
    static let stripeRefundsLive: Self = "Stripe Refunds Live"
    static let stripeConfirmationTokenLive: Self = "Stripe Confirmation Token Live"
    static let stripeTokensLive: Self = "Stripe Tokens Live"
    static let stripePaymentMethodsLive: Self = "Stripe Payment Methods Live"
    static let stripeProductsLive: Self = "Stripe Products Live"
    static let stripeCheckoutLive: Self = "Stripe Checkout Live"
    static let stripePaymentLinkLive: Self = "Stripe Payment Link Live"
    static let stripeBillingLive: Self = "Stripe Billing Live"
    static let stripeCapitalLive: Self = "Stripe Capital Live"
    static let stripeConnectLive: Self = "Stripe Connect Live"
    static let stripeFraudLive: Self = "Stripe Fraud Live"
    static let stripeIssuingLive: Self = "Stripe Issuing Live"
    static let stripeTerminalLive: Self = "Stripe Terminal Live"
    static let stripeTreasuryLive: Self = "Stripe Treasury Live"
    static let stripeEntitlementsLive: Self = "Stripe Entitlements Live"
    static let stripeSigmaLive: Self = "Stripe Sigma Live"
    static let stripeReportingLive: Self = "Stripe Reporting Live"
    static let stripeFinancialConnectionsLive: Self = "Stripe Financial Connections Live"
    static let stripeTaxLive: Self = "Stripe Tax Live"
    static let stripeIdentityLive: Self = "Stripe Identity Live"
    static let stripeCryptoLive: Self = "Stripe Crypto Live"
    static let stripeClimateLive: Self = "Stripe Climate Live"
    static let stripeForwardingLive: Self = "Stripe Forwarding Live"
    static let stripeWebhooksLive: Self = "Stripe Webhooks Live"
    static let stripeLiveShared: Self = "Stripe Live Shared"
}

extension Target.Dependency {
    static var stripeLive: Self { .target(name: .stripeLive) }
    static var stripeBalanceLive: Self { .target(name: .stripeBalanceLive) }
    static var stripeBalanceTransactionsLive: Self { .target(name: .stripeBalanceTransactionsLive) }
    static var stripeChargesLive: Self { .target(name: .stripeChargesLive) }
    static var stripeCustomersLive: Self { .target(name: .stripeCustomersLive) }
    static var stripeCustomerSessionLive: Self { .target(name: .stripeCustomerSessionLive) }
    static var stripeDisputesLive: Self { .target(name: .stripeDisputesLive) }
    static var stripeEventsLive: Self { .target(name: .stripeEventsLive) }
    static var stripeEventDestinationsLive: Self { .target(name: .stripeEventDestinationsLive) }
    static var stripeFilesLive: Self { .target(name: .stripeFilesLive) }
    static var stripeFileLinksLive: Self { .target(name: .stripeFileLinksLive) }
    static var stripeMandatesLive: Self { .target(name: .stripeMandatesLive) }
    static var stripePaymentIntentsLive: Self { .target(name: .stripePaymentIntentsLive) }
    static var stripeSetupIntentsLive: Self { .target(name: .stripeSetupIntentsLive) }
    static var stripeSetupAttemptsLive: Self { .target(name: .stripeSetupAttemptsLive) }
    static var stripePayoutsLive: Self { .target(name: .stripePayoutsLive) }
    static var stripeRefundsLive: Self { .target(name: .stripeRefundsLive) }
    static var stripeConfirmationTokenLive: Self { .target(name: .stripeConfirmationTokenLive) }
    static var stripeTokensLive: Self { .target(name: .stripeTokensLive) }
    static var stripePaymentMethodsLive: Self { .target(name: .stripePaymentMethodsLive) }
    static var stripeProductsLive: Self { .target(name: .stripeProductsLive) }
    static var stripeCheckoutLive: Self { .target(name: .stripeCheckoutLive) }
    static var stripePaymentLinkLive: Self { .target(name: .stripePaymentLinkLive) }
    static var stripeBillingLive: Self { .target(name: .stripeBillingLive) }
    static var stripeCapitalLive: Self { .target(name: .stripeCapitalLive) }
    static var stripeConnectLive: Self { .target(name: .stripeConnectLive) }
    static var stripeFraudLive: Self { .target(name: .stripeFraudLive) }
    static var stripeIssuingLive: Self { .target(name: .stripeIssuingLive) }
    static var stripeTerminalLive: Self { .target(name: .stripeTerminalLive) }
    static var stripeTreasuryLive: Self { .target(name: .stripeTreasuryLive) }
    static var stripeEntitlementsLive: Self { .target(name: .stripeEntitlementsLive) }
    static var stripeSigmaLive: Self { .target(name: .stripeSigmaLive) }
    static var stripeReportingLive: Self { .target(name: .stripeReportingLive) }
    static var stripeFinancialConnectionsLive: Self { .target(name: .stripeFinancialConnectionsLive) }
    static var stripeTaxLive: Self { .target(name: .stripeTaxLive) }
    static var stripeIdentityLive: Self { .target(name: .stripeIdentityLive) }
    static var stripeCryptoLive: Self { .target(name: .stripeCryptoLive) }
    static var stripeClimateLive: Self { .target(name: .stripeClimateLive) }
    static var stripeForwardingLive: Self { .target(name: .stripeForwardingLive) }
    static var stripeWebhooksLive: Self { .target(name: .stripeWebhooksLive) }
    static var stripeLiveShared: Self { .target(name: .stripeLiveShared) }
}

extension Target.Dependency {
    static var stripeTypes: Self { .product(name: "Stripe Types", package: "swift-stripe-types") }
    static var stripeBalanceTypes: Self { .product(name: "Stripe Balance Types", package: "swift-stripe-types") }
    static var stripeBalanceTransactionsTypes: Self { .product(name: "Stripe Balance Transactions Types", package: "swift-stripe-types") }
    static var stripeChargesTypes: Self { .product(name: "Stripe Charges Types", package: "swift-stripe-types") }
    static var stripeCustomersTypes: Self { .product(name: "Stripe Customers Types", package: "swift-stripe-types") }
    static var stripeCustomerSessionTypes: Self { .product(name: "Stripe Customer Session Types", package: "swift-stripe-types") }
    static var stripeDisputesTypes: Self { .product(name: "Stripe Disputes Types", package: "swift-stripe-types") }
    static var stripeEventsTypes: Self { .product(name: "Stripe Events Types", package: "swift-stripe-types") }
    static var stripeEventDestinationsTypes: Self { .product(name: "Stripe Event Destinations Types", package: "swift-stripe-types") }
    static var stripeFilesTypes: Self { .product(name: "Stripe Files Types", package: "swift-stripe-types") }
    static var stripeFileLinksTypes: Self { .product(name: "Stripe File Links Types", package: "swift-stripe-types") }
    static var stripeMandatesTypes: Self { .product(name: "Stripe Mandates Types", package: "swift-stripe-types") }
    static var stripePaymentIntentsTypes: Self { .product(name: "Stripe Payment Intents Types", package: "swift-stripe-types") }
    static var stripeSetupIntentsTypes: Self { .product(name: "Stripe Setup Intents Types", package: "swift-stripe-types") }
    static var stripeSetupAttemptsTypes: Self { .product(name: "Stripe Setup Attempts Types", package: "swift-stripe-types") }
    static var stripePayoutsTypes: Self { .product(name: "Stripe Payouts Types", package: "swift-stripe-types") }
    static var stripeRefundsTypes: Self { .product(name: "Stripe Refunds Types", package: "swift-stripe-types") }
    static var stripeConfirmationTokenTypes: Self { .product(name: "Stripe Confirmation Token Types", package: "swift-stripe-types") }
    static var stripeTokensTypes: Self { .product(name: "Stripe Tokens Types", package: "swift-stripe-types") }
    static var stripePaymentMethodsTypes: Self { .product(name: "Stripe Payment Methods Types", package: "swift-stripe-types") }
    static var stripeProductsTypes: Self { .product(name: "Stripe Products Types", package: "swift-stripe-types") }
    static var stripeCheckoutTypes: Self { .product(name: "Stripe Checkout Types", package: "swift-stripe-types") }
    static var stripePaymentLinkTypes: Self { .product(name: "Stripe Payment Link Types", package: "swift-stripe-types") }
    static var stripeBillingTypes: Self { .product(name: "Stripe Billing Types", package: "swift-stripe-types") }
    static var stripeCapitalTypes: Self { .product(name: "Stripe Capital Types", package: "swift-stripe-types") }
    static var stripeConnectTypes: Self { .product(name: "Stripe Connect Types", package: "swift-stripe-types") }
    static var stripeFraudTypes: Self { .product(name: "Stripe Fraud Types", package: "swift-stripe-types") }
    static var stripeIssuingTypes: Self { .product(name: "Stripe Issuing Types", package: "swift-stripe-types") }
    static var stripeTerminalTypes: Self { .product(name: "Stripe Terminal Types", package: "swift-stripe-types") }
    static var stripeTreasuryTypes: Self { .product(name: "Stripe Treasury Types", package: "swift-stripe-types") }
    static var stripeEntitlementsTypes: Self { .product(name: "Stripe Entitlements Types", package: "swift-stripe-types") }
    static var stripeSigmaTypes: Self { .product(name: "Stripe Sigma Types", package: "swift-stripe-types") }
    static var stripeReportingTypes: Self { .product(name: "Stripe Reporting Types", package: "swift-stripe-types") }
    static var stripeFinancialConnectionsTypes: Self { .product(name: "Stripe Financial Connections Types", package: "swift-stripe-types") }
    static var stripeTaxTypes: Self { .product(name: "Stripe Tax Types", package: "swift-stripe-types") }
    static var stripeIdentityTypes: Self { .product(name: "Stripe Identity Types", package: "swift-stripe-types") }
    static var stripeCryptoTypes: Self { .product(name: "Stripe Crypto Types", package: "swift-stripe-types") }
    static var stripeClimateTypes: Self { .product(name: "Stripe Climate Types", package: "swift-stripe-types") }
    static var stripeForwardingTypes: Self { .product(name: "Stripe Forwarding Types", package: "swift-stripe-types") }
    static var stripeWebhooksTypes: Self { .product(name: "Stripe Webhooks Types", package: "swift-stripe-types") }
}

extension Target.Dependency {
    static var serverFoundation: Self { .product(name: "ServerFoundation", package: "swift-server-foundation") }
    static var environmentVariables: Self { .product(name: "EnvironmentVariables", package: "swift-environment-variables") }
    static var authenticating: Self { .product(name: "Authenticating", package: "swift-authenticating") }
    static var dependenciesMacros: Self { .product(name: "DependenciesMacros", package: "swift-dependencies") }
    static var dependenciesTestSupport: Self { .product(name: "DependenciesTestSupport", package: "swift-dependencies") }
    static var tagged: Self { .product(name: "Tagged", package: "swift-tagged") }
}

let package = Package(
    name: "swift-stripe-live",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(name: .stripeLive, targets: [.stripeLive]),
        .library(name: .stripeBalanceLive, targets: [.stripeBalanceLive]),
        .library(name: .stripeBalanceTransactionsLive, targets: [.stripeBalanceTransactionsLive]),
        .library(name: .stripeChargesLive, targets: [.stripeChargesLive]),
        .library(name: .stripeCustomersLive, targets: [.stripeCustomersLive]),
        .library(name: .stripeCustomerSessionLive, targets: [.stripeCustomerSessionLive]),
        .library(name: .stripeDisputesLive, targets: [.stripeDisputesLive]),
        .library(name: .stripeEventsLive, targets: [.stripeEventsLive]),
        .library(name: .stripeEventDestinationsLive, targets: [.stripeEventDestinationsLive]),
        .library(name: .stripeFilesLive, targets: [.stripeFilesLive]),
        .library(name: .stripeFileLinksLive, targets: [.stripeFileLinksLive]),
        .library(name: .stripeMandatesLive, targets: [.stripeMandatesLive]),
        .library(name: .stripePaymentIntentsLive, targets: [.stripePaymentIntentsLive]),
        .library(name: .stripeSetupIntentsLive, targets: [.stripeSetupIntentsLive]),
        .library(name: .stripeSetupAttemptsLive, targets: [.stripeSetupAttemptsLive]),
        .library(name: .stripePayoutsLive, targets: [.stripePayoutsLive]),
        .library(name: .stripeRefundsLive, targets: [.stripeRefundsLive]),
        .library(name: .stripeConfirmationTokenLive, targets: [.stripeConfirmationTokenLive]),
        .library(name: .stripeTokensLive, targets: [.stripeTokensLive]),
        .library(name: .stripePaymentMethodsLive, targets: [.stripePaymentMethodsLive]),
        .library(name: .stripeProductsLive, targets: [.stripeProductsLive]),
        .library(name: .stripeCheckoutLive, targets: [.stripeCheckoutLive]),
        .library(name: .stripePaymentLinkLive, targets: [.stripePaymentLinkLive]),
        .library(name: .stripeBillingLive, targets: [.stripeBillingLive]),
        .library(name: .stripeCapitalLive, targets: [.stripeCapitalLive]),
        .library(name: .stripeConnectLive, targets: [.stripeConnectLive]),
        .library(name: .stripeFraudLive, targets: [.stripeFraudLive]),
        .library(name: .stripeIssuingLive, targets: [.stripeIssuingLive]),
        .library(name: .stripeTerminalLive, targets: [.stripeTerminalLive]),
        .library(name: .stripeTreasuryLive, targets: [.stripeTreasuryLive]),
        .library(name: .stripeEntitlementsLive, targets: [.stripeEntitlementsLive]),
        .library(name: .stripeSigmaLive, targets: [.stripeSigmaLive]),
        .library(name: .stripeReportingLive, targets: [.stripeReportingLive]),
        .library(name: .stripeFinancialConnectionsLive, targets: [.stripeFinancialConnectionsLive]),
        .library(name: .stripeTaxLive, targets: [.stripeTaxLive]),
        .library(name: .stripeIdentityLive, targets: [.stripeIdentityLive]),
        .library(name: .stripeCryptoLive, targets: [.stripeCryptoLive]),
        .library(name: .stripeClimateLive, targets: [.stripeClimateLive]),
        .library(name: .stripeForwardingLive, targets: [.stripeForwardingLive]),
        .library(name: .stripeWebhooksLive, targets: [.stripeWebhooksLive]),
        .library(name: .stripeLiveShared, targets: [.stripeLiveShared])
    ],
    dependencies: [
        .package(url: "https://github.com/coenttb/swift-authenticating.git", from: "0.0.1"),
        .package(url: "https://github.com/coenttb/swift-environment-variables.git", from: "0.0.1"),
        .package(url: "https://github.com/coenttb/swift-server-foundation.git", from: "0.3.0"),
        .package(url: "https://github.com/coenttb/swift-stripe-types.git", from: "0.0.1"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.9.2"),
        .package(url: "https://github.com/pointfreeco/swift-tagged.git", from: "0.10.0")
    ],
    targets: [
        .target(
            name: .stripeLiveShared,
            dependencies: [
                .serverFoundation,
                .environmentVariables,
                .authenticating
            ]
        ),
        .target(
            name: .stripeLive,
            dependencies: [
                .stripeTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros,
                .stripeBalanceLive,
                .stripeBalanceTransactionsLive,
                .stripeChargesLive,
                .stripeCustomersLive,
                .stripeCustomerSessionLive,
                .stripeDisputesLive,
                .stripeEventsLive,
                .stripeEventDestinationsLive,
                .stripeFilesLive,
                .stripeFileLinksLive,
                .stripeMandatesLive,
                .stripePaymentIntentsLive,
                .stripeSetupIntentsLive,
                .stripeSetupAttemptsLive,
                .stripePayoutsLive,
                .stripeRefundsLive,
                .stripeConfirmationTokenLive,
                .stripeTokensLive,
                .stripePaymentMethodsLive,
                .stripeProductsLive,
                .stripeCheckoutLive,
                .stripePaymentLinkLive,
                .stripeBillingLive,
                .stripeCapitalLive,
                .stripeConnectLive,
                .stripeFraudLive,
                .stripeIssuingLive,
                .stripeTerminalLive,
                .stripeTreasuryLive,
                .stripeEntitlementsLive,
                .stripeSigmaLive,
                .stripeReportingLive,
                .stripeFinancialConnectionsLive,
                .stripeTaxLive,
                .stripeIdentityLive,
                .stripeCryptoLive,
                .stripeClimateLive,
                .stripeForwardingLive,
                .stripeWebhooksLive
            ]
        ),
        .testTarget(
            name: "Stripe Live Shared Tests",
            dependencies: [
                .stripeLiveShared,
                .dependenciesTestSupport
            ]
        ),
        .testTarget(
            name: "Stripe Live Tests",
            dependencies: [
                .stripeLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeBalanceLive,
            dependencies: [
                .stripeBalanceTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Balance Live Tests",
            dependencies: [
                .stripeBalanceLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeBalanceTransactionsLive,
            dependencies: [
                .stripeBalanceTransactionsTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Balance Transactions Live Tests",
            dependencies: [
                .stripeBalanceTransactionsLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeChargesLive,
            dependencies: [
                .stripeChargesTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Charges Live Tests",
            dependencies: [
                .stripeChargesLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeCustomersLive,
            dependencies: [
                .stripeCustomersTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Customers Live Tests",
            dependencies: [
                .stripeCustomersLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeCustomerSessionLive,
            dependencies: [
                .stripeCustomerSessionTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Customer Session Live Tests",
            dependencies: [
                .stripeCustomerSessionLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeDisputesLive,
            dependencies: [
                .stripeDisputesTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Disputes Live Tests",
            dependencies: [
                .stripeDisputesLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeEventsLive,
            dependencies: [
                .stripeEventsTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Events Live Tests",
            dependencies: [
                .stripeEventsLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeEventDestinationsLive,
            dependencies: [
                .stripeEventDestinationsTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Event Destinations Live Tests",
            dependencies: [
                .stripeEventDestinationsLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeFilesLive,
            dependencies: [
                .stripeFilesTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Files Live Tests",
            dependencies: [
                .stripeFilesLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeFileLinksLive,
            dependencies: [
                .stripeFileLinksTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe File Links Live Tests",
            dependencies: [
                .stripeFileLinksLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeMandatesLive,
            dependencies: [
                .stripeMandatesTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Mandates Live Tests",
            dependencies: [
                .stripeMandatesLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripePaymentIntentsLive,
            dependencies: [
                .stripePaymentIntentsTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Payment Intents Live Tests",
            dependencies: [
                .stripePaymentIntentsLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeSetupIntentsLive,
            dependencies: [
                .stripeSetupIntentsTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Setup Intents Live Tests",
            dependencies: [
                .stripeSetupIntentsLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeSetupAttemptsLive,
            dependencies: [
                .stripeSetupAttemptsTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Setup Attempts Live Tests",
            dependencies: [
                .stripeSetupAttemptsLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripePayoutsLive,
            dependencies: [
                .stripePayoutsTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Payouts Live Tests",
            dependencies: [
                .stripePayoutsLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeRefundsLive,
            dependencies: [
                .stripeRefundsTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Refunds Live Tests",
            dependencies: [
                .stripeRefundsLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeConfirmationTokenLive,
            dependencies: [
                .stripeConfirmationTokenTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Confirmation Token Live Tests",
            dependencies: [
                .stripeConfirmationTokenLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeTokensLive,
            dependencies: [
                .stripeTokensTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Tokens Live Tests",
            dependencies: [
                .stripeTokensLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripePaymentMethodsLive,
            dependencies: [
                .stripePaymentMethodsTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Payment Methods Live Tests",
            dependencies: [
                .stripePaymentMethodsLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeProductsLive,
            dependencies: [
                .stripeProductsTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Products Live Tests",
            dependencies: [
                .stripeProductsLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeCheckoutLive,
            dependencies: [
                .stripeCheckoutTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Checkout Live Tests",
            dependencies: [
                .stripeCheckoutLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripePaymentLinkLive,
            dependencies: [
                .stripePaymentLinkTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Payment Link Live Tests",
            dependencies: [
                .stripePaymentLinkLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeBillingLive,
            dependencies: [
                .stripeBillingTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Billing Live Tests",
            dependencies: [
                .stripeBillingLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeCapitalLive,
            dependencies: [
                .stripeCapitalTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Capital Live Tests",
            dependencies: [
                .stripeCapitalLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeConnectLive,
            dependencies: [
                .stripeConnectTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Connect Live Tests",
            dependencies: [
                .stripeConnectLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeFraudLive,
            dependencies: [
                .stripeFraudTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Fraud Live Tests",
            dependencies: [
                .stripeFraudLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeIssuingLive,
            dependencies: [
                .stripeIssuingTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Issuing Live Tests",
            dependencies: [
                .stripeIssuingLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeTerminalLive,
            dependencies: [
                .stripeTerminalTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Terminal Live Tests",
            dependencies: [
                .stripeTerminalLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeTreasuryLive,
            dependencies: [
                .stripeTreasuryTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Treasury Live Tests",
            dependencies: [
                .stripeTreasuryLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeEntitlementsLive,
            dependencies: [
                .stripeEntitlementsTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Entitlements Live Tests",
            dependencies: [
                .stripeEntitlementsLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeSigmaLive,
            dependencies: [
                .stripeSigmaTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Sigma Live Tests",
            dependencies: [
                .stripeSigmaLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeReportingLive,
            dependencies: [
                .stripeReportingTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Reporting Live Tests",
            dependencies: [
                .stripeReportingLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeFinancialConnectionsLive,
            dependencies: [
                .stripeFinancialConnectionsTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Financial Connections Live Tests",
            dependencies: [
                .stripeFinancialConnectionsLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeTaxLive,
            dependencies: [
                .stripeTaxTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Tax Live Tests",
            dependencies: [
                .stripeTaxLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeIdentityLive,
            dependencies: [
                .stripeIdentityTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Identity Live Tests",
            dependencies: [
                .stripeIdentityLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeCryptoLive,
            dependencies: [
                .stripeCryptoTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Crypto Live Tests",
            dependencies: [
                .stripeCryptoLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeClimateLive,
            dependencies: [
                .stripeClimateTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Climate Live Tests",
            dependencies: [
                .stripeClimateLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeForwardingLive,
            dependencies: [
                .stripeForwardingTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Forwarding Live Tests",
            dependencies: [
                .stripeForwardingLive,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .stripeWebhooksLive,
            dependencies: [
                .stripeWebhooksTypes,
                .stripeLiveShared,
                .serverFoundation,
                .tagged,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: "Stripe Webhooks Live Tests",
            dependencies: [
                .stripeWebhooksLive,
                .dependenciesTestSupport
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("MemberImportVisibility"),
    .enableUpcomingFeature("StrictUnsafe"),
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
//    .unsafeFlags(["-warnings-as-errors"]),
    // .unsafeFlags([
    //   "-Xfrontend",
    //   "-warn-long-function-bodies=50",
    //   "-Xfrontend",
    //   "-warn-long-expression-type-checking=50",
    // ])
]

for index in package.targets.indices {
    package.targets[index].swiftSettings = (package.targets[index].swiftSettings ?? []) + swiftSettings
}
