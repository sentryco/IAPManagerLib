import Foundation
import TPInAppReceipt
/**
 * Apple recommends to perform receipt validation right after your app is launched. For additional security, you may repeat this check periodically while your application is running. NOTE: If validation fails in iOS, try to refresh the receipt first.
 * - Note: Has a lot of comments regarding receipt: https://github.com/Cocoanetics/Kvitto/blob/develop/Core/Source/InAppPurchaseReceipt.swift
 * - Important: ⚠️️ Local receipt validation is applicable only for non-consumable products and auto-renewable subscriptions. 
 */
public final class LocalReceiptValidator {
   /**
    * Validates, refreshes and returns purchases
    * - Description: We can assert if purchases has expired and what type they are etc
    * - Remark: This may throw error when testing local App purchase if receipt hasn't been generated before etc. Making a purchase may resolve it etc
    * - Remark: Verify that the receipt is properly signed by Apple
    * - Remark: Return receipt data from the application bundle. This is read from `Bundle.main.appStoreReceiptURL`.
    * - Fixme: ⚠️️ Verify that the bundle identifier in the receipt matches a hard-coded constant containing the CFBundleIdentifier value you expect in the Info.plist file. If they do not match, validation fails
    * - Fixme: ⚠️️ We store one receipt in local dir, this receipt contains all relevcant data to validate all current purchases, I think
    * - Parameters:
    *   - refresh: User is responsible for asserting if there is network-connectivity
    *   - onComplete: Handler
    */
   public static func getPurchases(refresh: Bool, onComplete: @escaping LocalReceiptValidator.OnGetPurchasesComplete/*?*/) {
      do {
         let receipt: InAppReceipt = try InAppReceipt.localReceipt() // Initialize receipt
         try receipt.validate() // Validate the receipt
         if refresh {
            InAppReceipt.refresh { (error: Error?) in // Refresh the receipt if `refresh` is true
               if let err = error {
                  onComplete/*?*/(.failure(err)) // Call the `onComplete` completion handler with a failure result if there is an error
               } else {
                  onComplete/*?*/(.success(receipt.purchases)) // Call the `onComplete` completion handler with a success result and the purchases if there is no error
               }
            }
         } else {
            onComplete/*?*/(.success(receipt.purchases)) // Call the `onComplete` completion handler with a success result and the purchases if `refresh` is false
         }
      } catch {
         onComplete/*?*/(.failure(error)) // Call the `onComplete` completion handler with a failure result if there is an error
      }
   }
}
/**
 * Asserter
 */
extension LocalReceiptValidator {
   /**
    * Check if user has already purchased the specific IAP product
    * - Parameter prodID: the IAP Product Identifier
    * - Returns: boolean
    * - Fixme: ⚠️️ make it throw?
    */
   public static func isProductPurchased(prodID: String) -> Bool {
      if let receipt: InAppReceipt = try? InAppReceipt.localReceipt() { // Get the local receipt
         if receipt.containsPurchase(ofProductIdentifier: prodID) { // Check if the receipt contains a purchase with the given product identifier
            return true // Return true if the receipt contains a purchase with the given product identifier
         }
      }
      return false // Return false if the receipt does not contain a purchase with the given product identifier or there is an error getting the local receipt
   }
   /**
    * Check if user has active subscription. If product identifier is nil, then it will check
    * - Remark: If user has any active subscriptions regardless of product identifier
    * - Fixme: ⚠️️ make it throw?
    * - Parameter prodID: The product identifier of the subscription
    * - Returns: boolean
    */
   public static func isSubscriptionActive(prodID: String?) -> Bool {
      if let receipt: InAppReceipt = try? InAppReceipt.localReceipt() { // Get the local receipt
         if let prodID: String = prodID { // Check if the product identifier is not nil
            return receipt.hasActiveAutoRenewableSubscription(ofProductIdentifier: prodID, forDate: Date()) // Return true if the receipt has an active auto-renewable subscription with the given product identifier and current date
         }
         return receipt.hasActiveAutoRenewablePurchases // Return true if the receipt has any active auto-renewable purchases
      }
      return false // Return false if there is an error getting the local receipt
   }
}
/**
 * Helpers
 */
extension Array where Element == InAppPurchase {
   /**
    * Type that customers purchase once. They don't expire
    */
   public var nonConsumable: [InAppPurchase] {
      self.filter({ $0.productType == .nonConsumable }) // Filter the array to only include non-consumable products
   }
   /**
    * Returns all auto renewable `InAppPurchase`s
    */
   public var autoRenewable: [InAppPurchase] {
      self.filter({ $0.isRenewableSubscription }) // Filter the array to only include products that are renewable subscriptions
   }
   /**
    * Returns all ACTIVE auto renewable `InAppPurchase`s
    */
   public var activeAutoRenewableSubscription: [InAppPurchase] {
      self.filter({
         $0.isRenewableSubscription && // Filter the array to only include products that are renewable subscriptions
         $0.isActiveAutoRenewableSubscription(forDate: Date()) // Filter the array to only include products that have an active auto-renewable subscription with the current date
      })
   }
}
/**
 * Const
 */
extension LocalReceiptValidator {
   // typealias PurchasesAndActivePurchases = (purchases: [InAppPurchase], activePurchases: [InAppPurchase])
   // typealias OnValidateComplete = (Result<PurchasesAndActivePurchases, Error>) -> Void
   public typealias OnGetPurchasesComplete = (Result<[InAppPurchase], Error>) -> Void
}
// - Fixme: ⚠️️ remove soon?
//let receipt = try InAppReceipt.receipt(from: receiptData)
//* let receipt: InAppReceipt = try InAppReceipt.localReceipt()
//* let receipt = try InAppReceipt() // Returns local receipt
//* try receipt.verify()
//* let hasPurchases = receipt.hasPurchases /// Check whether receipt contains any purchases
//* let base64Receipt: String = receipt.base64 /// Base64 Encoded Receipt

// extension LocalReceiptValidator {
   // Retrieve Original TransactionIdentifier for Product Name
//   receipt.originalTransactionIdentifier(ofProductIdentifier: subscriptionName)

   // Retrieve Active Auto Renewable Subscription's Purchases for Product Name and Specific Date
//   receipt.activeAutoRenewableSubscriptionPurchases(ofProductIdentifier: subscriptionName, forDate: Date())

   // Retrieve All Purchases for Product Name
//   receipt.purchases(ofProductIdentifier: subscriptionName)
// }
