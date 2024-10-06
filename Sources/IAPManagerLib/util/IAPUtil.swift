import Foundation // Import the Foundation framework
import StoreKit // Import the StoreKit framework
import TPInAppReceipt // Import the TPInAppReceipt framework
import Logger // Import the Logger framework

public final class IAPUtil {
   /**
    * Check if customer can make payments before showing IAP. Underage / no creditcard etc
    * - Description: In case parental control disable kids to buy app, this will return false
    * - Important: ⚠️️ deal with this case in the app. Meaning we need to set products to n/a etc?
    * - Remark: Assert if the current device can make payments.
    * - returns: `false` if this device is not able or allowed to make payments
    */
   public class func canMakePayments() -> Bool {
      SKPaymentQueue.canMakePayments() // Check if the device is able to make payments
   }
   /**
    * - Fixme: ⚠️️ this is moved to SKProduct+Ext
    */
//   public static let priceFormatter: NumberFormatter = {
//      let formatter = NumberFormatter()
//      formatter.formatterBehavior = .behavior10_4
//      formatter.numberStyle = .currency
//      return formatter
//   }()
}
/**
 * Debugging
 */
extension IAPUtil {
   /**
    * Refresh local receipt
    */
   public static func refreshLocalReceipt() {
      Self.refreshLocalReceipt { (result: Result<[InAppPurchase], Error>) in // Refresh the local receipt and get the result
         Logger.debug("\(Trace.trace())") // Log a debug message with the current trace
         guard let purchases: [InAppPurchase] = try? result.get() else { 
            Logger.error("\(Trace.trace()) - Err: \(result.getError())") 
            return 
         } // Get the purchases from the result, log an error message if there is an error, and return if the purchases are nil
         purchases.forEach { 
            Logger.debug("\(Trace.trace()) - $0.productIdentifier: \($0.productIdentifier)") 
         } // Loop through each purchase and log a debug message with the product identifier
      }
   }
   /**
    * Test store-kit
    * ## Examples:
    * IAPUtil.testRequestProducts(products: Inventory.allProducts)
    * - Parameters:
    *   - products: The products that were requested
    *   - manager: The `IAPManager` instance that made the request
    */
   public static func testRequestProducts(products: [IAPProduct], manager: IAPManager) {
      Logger.debug("\(Trace.trace())") // Log a debug message with the current trace
      let prodIDS: Set<String> = .init(products.map { $0.id }) // Create a set of product IDs from the array of products
      manager.requestProducts(prodIDS: prodIDS) { (result: Result<[Any], Error>) in // Request the products from the product IDs and get the result
         Logger.debug("\(Trace.trace()) - requestProducts") // Log a debug message with the current trace and "requestProducts"
         guard let products: [SKProduct] = try? result.get() as? [SKProduct] else { Swift.print("Err ⚠️️: \(result.errorStr)"); return } // Get the products from the result, log an error message if there is an error, and return if the products are nil
         products.forEach { // Loop through each product
            Logger.debug("\(Trace.trace()) - $0.productIdentifier: \($0.productIdentifier)") // Log a debug message with the current trace and the product identifier
            // Swift.print("SKProduct title: \($0.localizedTitle)")
         }
      }
   }
   /**
    * Test validating receipt
    */
   public static func testValidatingReceipt() {
      Logger.debug("\(Trace.trace())") // Log a debug message with the current trace
      LocalReceiptValidator.getPurchases(refresh: true) { (result: Result<[InAppPurchase], Error>) in // Get the purchases from the local receipt and get the result
         Logger.debug("\(Trace.trace()) - getPurchases") // Log a debug message with the current trace and "getPurchases"
         guard let purchases: [InAppPurchase] = try? result.get() else { 
            Swift.print("testValidatingReceipt - Err: ⚠️️ \(result.getError())") 
            return
         } // Get the purchases from the result, log an error message if there is an error, and return if the purchases are nil
         Logger.debug("\(Trace.trace()) - purchases.count: \(purchases.count)") // Log a debug message with the current trace and the number of purchases
         purchases.forEach { // Loop through each purchase
            Logger.debug("\(Trace.trace()) - purchase.id: \($0.productIdentifier)") // Log a debug message with the current trace and the product identifier
         }
      }
   }
   /**
      * Restore purchases
      * - Parameter manager: The payment queue manager
      */
   public static func restorePurchases(manager: IAPManager) {
      manager.restorePurchases { (result: Result<[String], Error>) in // Restore the purchases and get the result
         guard let prodIDs: [String] = try? result.get() else { 
            Logger.error("\(Trace.trace()) - Err: \(result.getError())")
            return
         } // Get the product IDs from the result, log an error message if there is an error, and return if the product IDs are nil
         Logger.debug("\(Trace.trace()) - prodIDs: \(prodIDs)") // Log a debug message with the current trace and the product IDs
      }
   }
   /**
   * Refresh the in-app purchase receipt
   * - Fixme: ⚠️️ Add an example in the documentation
   * - Remark: Uses SKReceiptRefreshRequest to refresh the receipt. After the refresh, Bundle.main.appStoreReceiptURL will contain the refreshed receipt.
   * - Parameter onComplete: The completion handler to call when the refresh is complete
   */
   public static func refreshLocalReceipt(onComplete: LocalReceiptValidator.OnGetPurchasesComplete?) {
      Logger.debug("\(Trace.trace())") // Log a debug message with the current trace
      InAppReceipt.refresh { (error: Error?) in // Refresh the in-app receipt and get the error
         if let err: Error = error { // Check if there is an error
            onComplete?(.failure(err)) // Call the completion handler with the error if there is one
         } else {
            do {
               let receipt: InAppReceipt = try InAppReceipt.localReceipt() // Get the local receipt
               onComplete?(.success(receipt.purchases)) // Call the completion handler with the purchases from the receipt
            } catch {
               onComplete?(.failure(error)) // Call the completion handler with the error if there is one
               return
            }
         }
      }
   }
}
