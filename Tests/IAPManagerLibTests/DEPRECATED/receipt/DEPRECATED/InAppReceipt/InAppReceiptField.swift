import Foundation

public struct InAppReceiptField {
   static let environment: Int32 = 0 // Sandbox, Production, ProductionSandbox
   static let bundleIdentifier: Int32 = 2
   static let appVersion: Int32 = 3
   static let opaqueValue: Int32 = 4
   static let receiptHash: Int32 = 5 // SHA-1 Hash
   static let ageRating: Int32 = 10 // SHA-1 Hash
   static let receiptCreationDate: Int32 = 12
   static let inAppPurchaseReceipt: Int32 = 17 // The receipt for an in-app purchase.
   //TODO: case originalPurchaseDate = 18
   static let originalAppVersion: Int32 = 19
   static let expirationDate: Int32 = 21
   static let quantity: Int32 = 1701
   static let productIdentifier: Int32 = 1702
   static let transactionIdentifier: Int32 = 1703
   static let purchaseDate: Int32 = 1704
   static let originalTransactionIdentifier: Int32 = 1705
   static let originalPurchaseDate: Int32 = 1706
   static let productType: Int32 = 1707
   static let subscriptionExpirationDate: Int32 = 1708
   static let webOrderLineItemID: Int32 = 1711
   static let cancellationDate: Int32 = 1712
   static let subscriptionTrialPeriod: Int32 = 1713
   static let subscriptionIntroductoryPricePeriod: Int32 = 1719
   static let promotionalOfferIdentifier: Int32 = 1721
}
