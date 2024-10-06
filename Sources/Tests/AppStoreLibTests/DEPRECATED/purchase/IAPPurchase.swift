import Foundation
/**
 * - Fixme: ⚠️️ decode from payload?: https://github.com/tikhop/TPInAppReceipt/blob/master/Sources/InAppReceipt%2BASN1Decodable.swift
 */
public struct InAppPurchase {
   public var productIdentifier: String
   public var productType: InAppPurchase.`Type` = .unknown
   public var transactionIdentifier: String
   public var originalTransactionIdentifier: String
   public var purchaseDate: Date
   public var originalPurchaseDate: Date?
   public var subscriptionExpirationDate: Date?
   public var cancellationDate: Date?
   public var subscriptionTrialPeriod: Bool = false
   public var subscriptionIntroductoryPricePeriod: Bool = false
   public var webOrderLineItemID: Int?
   public var promotionalOfferIdentifier: String?
   public var quantity: Int = 1
   /**
    * - Parameters:
    *   - productIdentifier: The product identifier which purchase related to
    *   - productType: Product type
    *   - transactionIdentifier: Transaction identifier
    *   - originalTransactionIdentifier: Original Transaction identifier
    *   - purchaseDate: Purchase Date
    *   - originalPurchaseDate: Original Purchase Date. Returns `nil` when testing with StoreKitTest
    *   - subscriptionExpirationDate: Subscription Expiration Date. Returns `nil` if the purchase has been expired (in some cases)
    *   - cancellationDate: Cancellation Date. Returns `nil` if the purchase is not a renewable subscription
    *   - subscriptionTrialPeriod: This value is `true`if the customer’s subscription is currently in the free trial period, or `false` if not.
    *   - subscriptionIntroductoryPricePeriod: This value is `true` if the customer’s subscription is currently in an introductory price period, or `false` if not.
    *   - webOrderLineItemID: A unique identifier for purchase events across devices, including subscription-renewal events. This value is the primary key for identifying subscription purchases.
    *   - promotionalOfferIdentifier: The value is an identifier of the subscription offer that the user redeemed. Returns `nil` if  the user didn't use any subscription offers.
    *   - quantity: The number of consumable products purchased. The default value is `1` unless modified with a mutable payment. The maximum value is 10.
    */
   public init(productIdentifier: String, productType: InAppPurchase.`Type` = .unknown, transactionIdentifier: String, originalTransactionIdentifier: String, purchaseDate: Date, originalPurchaseDate: Date? = nil, subscriptionExpirationDate: Date? = nil, cancellationDate: Date? = nil, subscriptionTrialPeriod: Bool = false, subscriptionIntroductoryPricePeriod: Bool = false, webOrderLineItemID: Int? = nil, promotionalOfferIdentifier: String? = nil, quantity: Int = 1) {
      self.productIdentifier = productIdentifier
      self.productType = productType
      self.transactionIdentifier = transactionIdentifier
      self.originalTransactionIdentifier = originalTransactionIdentifier
      self.purchaseDate = purchaseDate
      self.originalPurchaseDate = originalPurchaseDate
      self.subscriptionExpirationDate = subscriptionExpirationDate
      self.cancellationDate = cancellationDate
      self.subscriptionTrialPeriod = subscriptionTrialPeriod
      self.subscriptionIntroductoryPricePeriod = subscriptionIntroductoryPricePeriod
      self.webOrderLineItemID = webOrderLineItemID
      self.promotionalOfferIdentifier = promotionalOfferIdentifier
      self.quantity = quantity
   }
}
extension InAppPurchase {
   /**
    * A Boolean value indicating whether the purchase is renewable subscription.
    */
   var isRenewableSubscription: Bool {
      subscriptionExpirationDate != nil
   }
   /**
    * Check whether the subscription is active for a specific date
    * - Parameter date: The date in which the auto-renewable subscription should be active.
    * - Returns: true if the latest auto-renewable subscription is active for the given date, false otherwise.
    */
   func isActiveAutoRenewableSubscription(forDate date: Date) -> Bool {
      assert(isRenewableSubscription, "\(productIdentifier) is not an auto-renewable subscription.")
      if cancellationDate != nil {
         return false
      }
      guard let expirationDate = subscriptionExpirationDate else { return false }
      return date >= purchaseDate && date < expirationDate
   }
}
extension InAppPurchase {
   public enum `Type`: Int32 {
      /// Type that we can't recognize for some reason
      case unknown = -1
      /// Type that customers purchase once. They don't expire.
      case nonConsumable
      /// Type that are depleted after one use. Customers can purchase them multiple times.
      case consumable
      // - Fixme: ⚠️️ description seems wrong?
      /// Type that customers purchase once and that renew automatically on a recurring basis until customers decide to cancel.
      case nonRenewingSubscription
      // - Fixme: ⚠️️ description seems wrong?
      /// Type that customers purchase and it provides access over a limited duration and don't renew automatically. Customers can purchase them again.
      case autoRenewableSubscription
   }
}
