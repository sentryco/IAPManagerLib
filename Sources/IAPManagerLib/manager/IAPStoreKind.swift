import Foundation
/**
 * API
 * - Fixme: ⚠️️ Possibly add bundle id variable as well? or get from info.plst?
 * - Fixme: ⚠️️ Rename to StoreKind? or not? definitly not, or?
 */
public protocol IAPStoreKind {
   var appID: String { get } // AppBundleIdentifier // "net.toolinbox.iap"
   /**
    * Buy a product registered in apple connect
    * - Description: A closure that is called when a product request has completed.
    *
    * - Parameters:
    *   - productID: The ID of the product that was requested.
    *   - onComplete: The closure to call when the product request has completed.
    */
   func purchaseProduct(productID: String, onComplete: OnPurchaseTransactionComplete?)
   /**
    * Checks with app-store if payment for period has been processed
    *
    * - Parameters:
    *   - productID: The ID of the product to validate the purchase for.
    *   - secret: The secret key for the app.
    *   - onComplete: The closure to call when the remote purchase validation has completed.
    */
   func validatePurchase(productID: String, secret: String, onComplete: OnRemotePurchaseValidationComplete?)
   /**
    * Get all purchases for the app
    * - Description: Requests the products with the given IDs from the app store.
    * - Fixme: ⚠️️ Rename to `getPurchase`? maybe not as its async etc maybe fetchProducts as an alt, as it sort of tries local first i guess?
    * - Parameters:
    *   - prodIDS: The IDs of the products to request.
    *   - onComplete: The closure to call when the product request has completed.
    */
   func requestProducts(prodIDS: Set<String>, onComplete: OnProductsRequestComplete?)
}
/**
 * Const - typealias
 */
extension IAPStoreKind {
   /**
    * Completion handler when validating online
    */
   public typealias OnRemotePurchaseValidationComplete = RemoteReceiptValidator.ValidateHandler // (_ productID: String, _ isValid: Bool) -> Void
   /**
    * Any is [SKProduct] (we use any so we can use DummyStore etc)
    * - Description: A closure that is called when a product request has completed.
    * - Fixme: ⚠️️ We could use T possibly as well. and diff on DummyStore<T> etc associateType etx
    * - Parameters:
    *   - products: The products that were requested.
    *
    */
   public typealias OnProductsRequestComplete = (Result<[Any], Error>) -> Void // cast any to SKProduct
   /**
    * Strings is _ ids: [String] (product ids)
    * - Description: A closure that is called when a purchase has been restored.
    *
    * - Parameters:
    *   - result: The result of the purchase restoration.
    */
   public typealias OnPurchaseRestored = (Result<[String], Error>) -> Void
}
/**
 * Const - type (observer)
 */
extension IAPStoreKind {
   /**
    * - Note: String is productID
    */
   public typealias OnPurchaseTransactionComplete = (Result<String, Error>) -> Void
   // typealias OnTransactionFailed = (_ reason: String) -> Void
   // typealias PurchaseHandler = (_ productIdentifier: String?, _ error: Error?) -> ()
}
