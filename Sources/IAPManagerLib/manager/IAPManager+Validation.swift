import Foundation
import StoreKit
import Logger
/**
 * Validation
 */
extension IAPManager {
   /**
    * Validate purchase on apple server
    * - Description: Get products with their expire date
    * - Remark: Don't use this in production, use local receipt, or revenuecat or your own server validator etc
    * - Remark: Lookup apple server for app-id, prod-ID, System.userID
    * - Remark: We directly validate with Apple's server. It's simple, but has risk. You decide to use your own server or not. Here's what Apple suggested: Use a trusted server to communicate with the App Store. Using your own server lets you design your app to recognize and trust only your server, and lets you ensure that your server connects with the App Store server. It is not possible to build a trusted connection between a user’s device and the App Store directly because you don’t control either end of that connection.
    * - Remark: Password is Only used for receipts that contain auto-renewable subscriptions.
    * - Fixme: ⚠️️ According to apple we should call production first then sandbox url etc
    * - Fixme: ⚠️️⚠️️⚠️️ Since app-store review board will test apps in sandbox, we should just have one AppStore, and not sandbox store. and rather call 2 urls first production, then that fails, then sandbox url kicks in, see that iap-lib in that gist that handles this
    * - Parameters:
    *   - productID: The product identifier to validate.
    *   - secret: It's your app’s shared secret (a hexadecimal string) which was generated on iTunesConnect.
    *   - onComplete: The completion handler to call when the validation is complete.
    */
   public func validatePurchase(productID: String, secret: String, onComplete: OnRemotePurchaseValidationComplete?) {
      onValidatePurchaseComplete = onComplete // Set the `onValidatePurchaseComplete` completion handler to the given completion handler
      RemoteReceiptValidator.validateReceipt(
         isProduction: false, // Whether to validate against the production server
         password: secret, // The shared secret for the receipt
         onComplete: onValidatePurchaseComplete // The completion handler for the validation
      ) // Validate the receipt with the given parameters
   }
}
/**
 * Extra
 */
extension IAPManager {
   /**
    * - Fixme: ⚠️️ Use Result
    */
   public typealias OnAssertPurchasedAndValid = (_ purchasedAndValid: Bool, _ prodID: String) -> Void
   /**
    * Check receipt or call network etc?
    * - Description: 1. get product, 2. validate receipt, 3. check if not expired
    * - Important: ⚠️️ Don't use this in production, use local receipt, or revenuecat or your own server validator etc
    * - Important: Only works for autoRenewable at the moment
    * - Fixme: ⚠️️ Add support for checking valid purchase for `nonConsumable`, see `LocalValidator` for flow etc
    * - Fixme: ⚠️️ Add onComplete in the first guard etc
    * - Fixme: ⚠️️ Rename to `isPurchaseActive` whats the diff between active and valid? i guess regarding expiration etc?
    * - Parameters:
    *   - prodID: The product identifier to check.
    *   - secret: Set your own SharedSecret, which was generated on iTunesConnect. "MyApp" etc
    *   - complete: The completion handler to call when the validation is complete.
     */
   public func isPurchaseValid(prodID: String, secret: String, complete: OnAssertPurchasedAndValid?) {
      requestProducts(prodIDS: [prodID]) { (result: Result<[Any], Error>) in
         guard let products: [SKProduct] = try? result.get() as? [SKProduct], // Get the products from the result
                  let product: SKProduct = products.first(where: { $0.productIdentifier == prodID }) // Get the product with the given product identifier
                  else { Logger.error("\(Trace.trace()) - Err: \(result.errorStr)"); return } // Log an error message and return if there is an error
               self.validatePurchase(productID: product.productIdentifier, secret: secret) { (result: Result<RemoteReceiptValidator.ValidityValue, Error>)  in // Call the `validatePurchase` method with the product identifier and secret
             // - Fixme: ⚠️️ do expiredate validation here etc?
            guard let val: RemoteReceiptValidator.ValidityValue = try? result.get(), // Get the value from the result
               let expireDate: Date = val.productWithExpireDate[product.productIdentifier], // Get the expiration date of the product with the given product identifier
                   // isValidReceipt
                  ReceiptStatus.valid.rawValue == val.statusCode, // Check if the status code of the validation result is valid
                  // hasNotExpired
                  expireDate <= Date() else { // Check if the expiration date is before or equal to the current date
               // -> false -> prompt alert with purchase button // -> feature should proceed aka add more devices than 2
               complete?(true, product.productIdentifier); return
            }
            complete?(false, product.productIdentifier) // Call the `complete` completion handler with a boolean indicating that the purchase is not valid and the product identifier
               }
      }
   }
}
