import Foundation
import StoreKit

// Restored product
/**
 * - Description: This struct represents a purchase made through the App Store, including the product identifier, quantity, and whether the transaction needs to be finished.
 * DEPRECATED ⚠️️
 */
public struct Purchase {
   // The product identifier which purchase related to
   public let productId: String
   public let quantity: Int
//   public let transaction: PaymentTransaction
//   public let originalTransaction: PaymentTransaction?
   public let needsFinishTransaction: Bool
}
//
//@objc public var productIdentifier: String { purchase.productIdentifier }
//
///// Product type
//@objc public var productType: Type { Type(rawValue: purchase.productType.rawValue) ?? .unknown }
//
///// Transaction identifier
//@objc public var transactionIdentifier: String { purchase.transactionIdentifier }
//
///// Original Transaction identifier
//@objc public var originalTransactionIdentifier: String { purchase.originalTransactionIdentifier }
//
///// Purchase Date
//@objc public var purchaseDate: Date { purchase.purchaseDate }
//
///// Original Purchase Date
//@objc public var originalPurchaseDate: Date { purchase.originalPurchaseDate }
//
///// Subscription Expiration Date. Returns `nil` if the purchase has been expired (in some cases)
//@objc public var subscriptionExpirationDate: Date? { purchase.subscriptionExpirationDate }
//
///// Cancellation Date. Returns a value if the transaction was refunded by customer support or the auto-renewable subscription plan was upgraded. Otherwise returns nil.
//@objc public var cancellationDate: Date? { purchase.cancellationDate }
//
///// This value is `true`if the customer’s subscription is currently in the free trial period, or `false` if not.
//@objc public var subscriptionTrialPeriod: Bool { purchase.subscriptionTrialPeriod }
//
///// This value is `true` if the customer’s subscription is currently in an introductory price period, or `false` if not.
//@objc public var subscriptionIntroductoryPricePeriod: Bool { purchase.subscriptionIntroductoryPricePeriod }
//
///// A unique identifier for purchase events across devices, including subscription-renewal events. This value is the primary key for identifying subscription purchases.
//@objc public var webOrderLineItemID: Int { purchase.webOrderLineItemID ?? NSNotFound }
//
///// The value is an identifier of the subscription offer that the user redeemed.
///// Returns `nil` if  the user didn't use any subscription offers.
//@objc public var promotionalOfferIdentifier: String? { purchase.promotionalOfferIdentifier }
//
///// The number of consumable products purchased
///// The default value is `1` unless modified with a mutable payment. The maximum value is 10.
//@objc public var quantity: Int { purchase.quantity }
