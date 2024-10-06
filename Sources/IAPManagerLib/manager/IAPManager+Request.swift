import Foundation
import StoreKit
import Logger
/**
 * Request delegate
 * - Description: Delegate callbacks when `requestProduct` is called
 */
extension IAPManager: SKProductsRequestDelegate {
   /**
    * Product request succeded
    * - Description: This is called as a result of calling `getPurchases`
    * - Fixme: ⚠️️ There is also: `response.invalidProductIdentifiers`
    * - Fixme: ⚠️️ We could also pass reponse in the `onComplete` and maybe also: `response.invalidProductIdentifiers`?
   * - Parameters:
   *   - request: The product request that succeeded.
   *   - response: The response of the product request.
    */
   public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
      Logger.debug("\(Trace.trace()) - didReceive for product request") // Log a debug message indicating that the product request was received
      productRequest = nil // Reset
      onProductsRequestComplete?(.success(response.products)) // Product declared in Itunes Connect with all the available information
      onProductsRequestComplete = nil // Reset (only one callback etc)
   }
/**
    * Product request Failed
    * - Parameters:
    *   - request: The product request that failed.
    *   - error: The error that caused the request to fail.
    */
   public func request(_ request: SKRequest, didFailWithError error: Error) {
      Logger.debug("\(Trace.trace()) - didFailWithError Error for request: \(error.localizedDescription)") // Log a debug message indicating that the request failed with an error
      productRequest = nil // Reset
      onProductsRequestComplete?(.failure(error)) // Call the completion handler with a failure result and the given error
      onProductsRequestComplete = nil // Reset (only one callback etc)
   }
}
