import Foundation

public struct ReceiptItem/*: Purchased*/: Codable {
   public var productId: String
   public var quantity: Int
   public var transactionId: String
   public var originalTransactionId: String
   public var purchaseDate: Date
   public var originalPurchaseDate: Date
   public var webOrderLineItemId: String?
   public var subscriptionExpirationDate: Date?
   public var cancellationDate: Date?
   public var isTrialPeriod: Bool
   public var isInIntroOfferPeriod: Bool
   public var isUpgraded: Bool
   /**
    * - Parameters:
    *   - productId: The product identifier of the item that was purchased. This value corresponds to the `productIdentifier` property of the `SKPayment` object stored in the transaction’s payment property.
    *   - quantity: The number of items purchased. This value corresponds to the `quantity` property of the `SKPayment` object stored in the transaction’s payment property.
    *   - transactionId: The transaction identifier of the item that was purchased. This value corresponds to the transaction’s `transactionIdentifier` property.
    *   - originalTransactionId: For a transaction that restores a previous transaction, the transaction identifier of the original transaction. Otherwise, identical to the transaction identifier. This value corresponds to the original transaction’s `transactionIdentifier` property. All receipts in a chain of renewals for an auto-renewable subscription have the same value for this field.
    *   - purchaseDate: The date and time that the item was purchased. This value corresponds to the transaction’s `transactionDate` property.
    *   - originalPurchaseDate: For a transaction that restores a previous transaction, the date of the original transaction. This value corresponds to the original transaction’s `transactionDate` property. In an auto-renewable subscription receipt, this indicates the beginning of the subscription period, even if the subscription has been renewed.
    *   - webOrderLineItemId: The primary key for identifying subscription purchases.
    *   - subscriptionExpirationDate: The expiration date for the subscription, expressed as the number of milliseconds since January 1, 1970, 00:00:00 GMT. This key is **only** present for **auto-renewable** subscription receipts.
    *   - cancellationDate: For a transaction that was canceled by Apple customer support, the time and date of the cancellation. Treat a canceled receipt the same as if no purchase had ever been made.
    *   - isTrialPeriod: Indicates whether or not the subscription item is currently within a given trial period.
    *   - isInIntroOfferPeriod: Indicates whether or not the subscription item is currently within an intro offer period.
    *   - isUpgraded: An indicator that a subscription has been canceled due to an upgrade. This field is only present for upgrade transactions.
    */
   public init(productId: String, quantity: Int, transactionId: String, originalTransactionId: String, purchaseDate: Date, originalPurchaseDate: Date, webOrderLineItemId: String?, subscriptionExpirationDate: Date?, cancellationDate: Date?, isTrialPeriod: Bool, isInIntroOfferPeriod: Bool, isUpgraded: Bool) {
      self.productId = productId
      self.quantity = quantity
      self.transactionId = transactionId
      self.originalTransactionId = originalTransactionId
      self.purchaseDate = purchaseDate
      self.originalPurchaseDate = originalPurchaseDate
      self.webOrderLineItemId = webOrderLineItemId
      self.subscriptionExpirationDate = subscriptionExpirationDate
      self.cancellationDate = cancellationDate
      self.isTrialPeriod = isTrialPeriod
      self.isInIntroOfferPeriod = isInIntroOfferPeriod
      self.isUpgraded = isUpgraded
   }
}
