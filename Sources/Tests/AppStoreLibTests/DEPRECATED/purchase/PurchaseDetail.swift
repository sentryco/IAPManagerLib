import Foundation
import StoreKit
/**
 * - Description: This struct represents the details of a purchase made through the App Store, including the product identifier, quantity, associated product, and whether the transaction needs to be finished.
 */
public struct PurchaseDetails {
   public let productId: String
   public let quantity: Int
   public let product: SKProduct
//   public let transaction: PaymentTransaction
//   public let originalTransaction: PaymentTransaction?
   public let needsFinishTransaction: Bool
}
