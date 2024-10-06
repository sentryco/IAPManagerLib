import Foundation // Provides fundamental and low-level classes for working with data
import StoreKit // Provides classes for making in-app purchases
import ResultSugar // Provides a set of operators and functions for working with Result types
import Logger // Provides a logging framework for debugging and diagnostics
/**
 * Commands
 */
extension IAPManager {
   /**
    * Buy the specific IAP Product
    * - Remark: There is also: `payment.quantity`, `payment.discount..` etc
    * - Fixme: ⚠️️ Maybe add: If you want to handle the timing to complete transaction, set `shouldCompleteImmediately` to false at initializing
    * - Fixme: ⚠️️ Add API for product: `SKProduct` as param as well: `SKPaymentQueue.default().add(SKPayment(product: SKProduct()))`
    * - Parameters:
    *   - productID: `ProductId` as specified in App-Store Connect
    *   - onComplete: Handler for result
    * - returns: A cancellable `InAppRequest` object
    */
   public func purchaseProduct(productID: String, onComplete: OnPurchaseTransactionComplete? = nil) {
      Logger.debug("\(Trace.trace()) - productID: \(productID)") // Log a debug message with the product ID
      onPurchaseTransactionComplete = onComplete // Set the completion handler for the purchase transaction
      let payment: SKMutablePayment = .init() // Create a new mutable payment object
      payment.productIdentifier = productID // Set the product identifier for the payment object
      SKPaymentQueue.default().add(payment) // Add the payment object to the payment queue
   }
   /**
    * Retrieve products information
    * - Description: Fetch Product Information
    * - Fixme: ⚠️️ Rename to `fetchProducts`? maybe not or? keep for now
    * - Parameters:
    *   - productIds: The set of product identifiers to retrieve corresponding products for
    *   - completion: Handler for result
    * - returns: A cancellable `InAppRequest` object
    */
   public func requestProducts(prodIDS: Set<String>, onComplete: OnProductsRequestComplete? = nil) {
      onProductsRequestComplete = onComplete // Assign callback
      productRequest?.cancel() // Reset previouse calls etc
      productRequest = nil // // Reset the request
      productRequest = .init(productIdentifiers: prodIDS) // Request to fetch information about SKProducts giving the products ID
      productRequest?.delegate = self // Set the delegate for the product request to self
      productRequest?.start() // Start the product request
   }
   /**
   * Restore completed Transaction
   * - Remark: Restore the user's purchases. Calling this method may present modal UI.
   * - Parameter onComplete: The completion handler to call when the restore is complete.
   * - Fixme: ⚠️️ When should we call this? I think when we install an app again etc?
   */
   public func restorePurchases(onComplete: OnPurchaseRestored?) {
      onPurchaseRestored = onComplete // Set the completion handler for the purchase restore
      SKPaymentQueue.default().restoreCompletedTransactions() // Event regarding a SKProduct
   }
}
