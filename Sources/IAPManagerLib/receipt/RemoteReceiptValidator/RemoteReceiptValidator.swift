import StoreKit
import Foundation
/**
 * Validates a receipt online
 * - Description: Sends a request to the iTunes server for validation
 * - Remark: ReceiptValidator directly validate with Apple's server. It's simple, but has risk. You decide to use your own server or not. Here's what Apple suggested: Use a trusted server to communicate with the App Store. Using your own server lets you design your app to recognize and trust only your server, and lets you ensure that your server connects with the App Store server. It is not possible to build a trusted connection between a user’s device and the App Store directly because you don’t control either end of that connection.
 * - Note: https://github.com/bizz84/SwiftyStoreKit/blob/master/Sources/SwiftyStoreKit/InAppReceipt.swift
 * - Note: Refreshing receipt: https://github.com/bizz84/SwiftyStoreKit/blob/master/Sources/SwiftyStoreKit/InAppReceiptRefreshRequest.swift
 * - Note: Validting receipt: https://github.com/bizz84/SwiftyStoreKit/blob/master/Sources/SwiftyStoreKit/InAppReceiptVerificator.swift
 * - Fixme: ⚠️️ Clean this class up
 */
public final class RemoteReceiptValidator {
   /**
    * Validate receipt
    * - Description: Attempts to make a validated receipt from the response and calls `onCompletion` when finished
    * - Remark: `password` cannot be `nil` if managing auto-renewing subscription products.
    * - Fixme: ⚠️️ There can be many things in the receipt, which statusCode belongs to which item? to all? or is it just a way to make sure it's not tampered with. And then we check expiration-date our selfs etc?
    * - Fixme: ⚠️️ Write more doc and example?
    * - Fixme: ⚠️️ Rename password to sharedSecret?
    * - Fixme: ⚠️️⚠️️⚠️️ implement prod/sandbox retry trick from here: https://github.com/bizz84/SwiftyStoreKit/blob/master/Sources/SwiftyStoreKit/AppleReceiptValidator.swift key to removing isProduction param, and pass appreview etc
    * - Parameters:
    *   - isProduction: Use sandbox or production URL // - Fixme: ⚠️️ what do we toggle on
    *   - password: Password to auth the verification (The shared secret is only used by the iTunes Store validation server for receipts that contain auto-renewable subscriptions. Therefore, this value is technically optional. However, attempts to validate receipts containing auto-renewing subscriptions will fail if this value is not provided. )
    *   - onComplete: Callback with product and expiration data  
    */
   public static func validateReceipt(isProduction: Bool?, password: String?, onComplete: ValidateHandler?) {
      guard let receiptRequestData: Data = receiptRequestData(appStoreReceiptURL, password: password),
            let url: URL = .init(string: serverURL(isProduction: isProduction)) else {
         onComplete?(.failure(NSError(domain: "Code: \(ReceiptStatus.noRecipt.rawValue)", code: 0))); return
      } // Check if the receipt request data and URL are not nil, otherwise call the `onComplete` completion handler with a failure result and return
      let request: NSMutableURLRequest = .init(url: url, httpMethod: "POST", httpBody: receiptRequestData) // Initialize the request with the URL, HTTP method, and receipt request data
      let task: URLSessionDataTask = URLSession.shared.dataTask(with: request as URLRequest) { (data: Data?, _: URLResponse?, error: Error?) in // Create a data task with the request
         guard let data: Data = data, error == nil else { onComplete?(.failure(error ?? NSError(domain: "data err", code: 0))); return } // Check if the data and error are not nil, otherwise call the `onComplete` completion handler with a failure result and return
         do {
            let json: [String: Any] = (try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]) ?? [:] // Parse the JSON data
            guard let products: ProductWithExpireDate = Self.parseValidateResultJSON(json) else { // Check if the products can be parsed from the JSON data
               onComplete?(.failure(NSError(domain: "unable to parse receipt", code: 0))) // Call the `onComplete` completion handler with a failure result if the products cannot be parsed
               return
            }
            // fix: use ReceiptStatus rawvalue instead of -999
            let statusCode: Int = (json["status"] as? Int) ?? -999 // Get the status code from the JSON data
            onComplete?(.success((statusCode, products, json))) // Call the `onComplete` completion handler with a success result and the status code, products, and JSON data
         } catch { onComplete?(.failure(error)); } // Call the `onComplete` completion handler with a failure result if there is an error parsing the JSON data
      }
      task.resume() // Begin network call
   }
}
