import Foundation
import StoreKit
import TPInAppReceipt
/**
 * Private helpers
 */
extension RemoteReceiptValidator {
   /**
    * Parse receipt
    * - Fixme: ⚠️️ Write description
    * - Fixme: ⚠️️ Figure out which product types this supports etc
    * - Parameter json: JSON to parse
    * - Returns: Product and expiration
    */
   internal static func parseValidateResultJSON(_ json: [String: Any]?) -> ProductWithExpireDate? {
      // - Fixme: ⚠️️ break out into own method
      let totalInAppPurchaseList: [[String: Any]] = { 
         let receipt: [String: Any]? = json?["receipt"] as? [String: Any] // Get the receipt dictionary from the JSON data
         let inAppPurchaseList: InAppPurchaseList = (receipt?["in_app"] as? [[String: Any]]) ?? [] // Get the in-app purchase list from the receipt dictionary, or an empty array if it is nil
         let latestInAppPurchaseList: InAppPurchaseList = (json?["latest_receipt_info"] as? [[String: Any]]) ?? [] // Get the latest in-app purchase list from the JSON data, or an empty array if it is nil
         return inAppPurchaseList + latestInAppPurchaseList // Concatenate the in-app purchase list and the latest in-app purchase list
      }()
      // fix: move to var, buggy in vscode etc
      typealias Tuple = (productDateDict: RemoteReceiptValidator.ProductDateDict, canceledProducts: RemoteReceiptValidator.ProductWithExpireDate)
      let tuple: Tuple = Self.productDateDictAndCanceledProducts(totalInAppPurchaseList: totalInAppPurchaseList) // Get the product date dictionary and canceled products from the total in-app purchase list
      return Self.products(productDateDict: tuple.productDateDict, canceledProducts: tuple.canceledProducts) // Return the products from the product date dictionary and canceled products
   }
   /**
    * Receipt request data
    * - Description: Creates the request data to send to the App Store server to get the receipt data.
    * - Parameters:
    *   - appStoreReceiptURL: The URL of the app store receipt to validate.
    *   - password: The password to use for validating the receipt.
    * - Returns: The request data to send to the App Store server to get the receipt data.
    */
   internal static func receiptRequestData(_ appStoreReceiptURL: URL?, password: String?) -> Data? {
      guard let receiptURL: URL = appStoreReceiptURL, let receiptData: Data = try? .init(contentsOf: receiptURL) else { return nil } // Check if the receipt URL and data are not nil, otherwise return nil
      do {
         let receiptData: String = receiptData.base64EncodedString() // Encode the receipt data as a base64 string
         var requestContents: [String: String] = ["receipt-data": receiptData] // Create a dictionary with the receipt data
         if let password: String = password { // Check if the password is not nil
            requestContents["password"] = password // Add the password to the dictionary
         }
         return try JSONSerialization.data(withJSONObject: requestContents, options: []) // Serialize the dictionary as JSON data
      } catch let error { NSLog("\(error)"); return nil } // Log any errors and return nil
   }
}
/**
 * Private helpers
 */
extension RemoteReceiptValidator {
   /**
   * Returns a tuple containing a dictionary of product date helpers and a dictionary of canceled products
   * - Fixme: ⚠️️ Simplify this method
   * - Parameter totalInAppPurchaseList: An array of dictionaries containing in-app purchase information
   * - Returns: A tuple containing a dictionary of product date helpers and a dictionary of canceled products
   */
   private static func productDateDictAndCanceledProducts(totalInAppPurchaseList: InAppPurchaseList) -> (ProductDateDict, ProductWithExpireDate) {
      var productDateDict: ProductDateDict = .init() // Initialize an empty dictionary to store the product date helpers
      var canceledProducts: ProductWithExpireDate = .init() // Initialize an empty dictionary to store the canceled products
      // - Fixme: ⚠️️ do reduce here?
      for inAppPurchase: [String: Any] in totalInAppPurchaseList { // Loop through each in-app purchase in the total in-app purchase list
         if let productID: String = inAppPurchase["product_id"] as? String, let purchaseDate: Date = parseDate(inAppPurchase["purchase_date_ms"] as? String) { // Get the product ID and purchase date from the in-app purchase
            let expiresDate: Date? = Self.parseDate(inAppPurchase["expires_date_ms"] as? String) // Get the expiration date from the in-app purchase
            let cancellationDate: Date? = Self.parseDate(inAppPurchase["cancellation_date_ms"] as? String) // Get the cancellation date from the in-app purchase
            let productDateHelper: ProductDateHelper = .init(purchaseDate: purchaseDate, expiresDate: expiresDate, canceledDate: cancellationDate) // Create a product date helper with the purchase date, expiration date, and cancellation date
            if productDateDict[productID] == nil { // Check if the product ID is not in the dictionary
               productDateDict[productID] = [productDateHelper] // Add the product date helper to the dictionary
            } else {
               productDateDict[productID]?.append(productDateHelper) // Append the product date helper to the array in the dictionary
            }
            if let cancellationDate: Date = cancellationDate { // Check if the cancellation date is not nil
               if let lastCanceledDate: Date = canceledProducts[productID] { // Check if the product ID is in the canceled products dictionary
                  if lastCanceledDate.timeIntervalSince1970 < cancellationDate.timeIntervalSince1970 { // Check if the last canceled date is earlier than the current cancellation date
                     canceledProducts[productID] = cancellationDate // Update the canceled products dictionary with the current cancellation date
                  }
               } else {
                  canceledProducts[productID] = cancellationDate // Add the cancellation date to the canceled products dictionary
               }
            }
         }
      }
      return (productDateDict, canceledProducts) // Return the product date dictionary and canceled products dictionary
   }
   /**
   * Returns a dictionary of products with their latest expiration dates and a dictionary of canceled products
   * - Fixme: ⚠️️ Simplify this method
   * - Parameter productDateDict: A dictionary of product date helpers for each product ID
   * - Parameter canceledProducts: A dictionary of canceled products with their cancellation dates
   * - Returns: A dictionary of products with their latest expiration dates and a dictionary of canceled products
   */
   private static func products(productDateDict: [String: [ProductDateHelper]], canceledProducts: ProductWithExpireDate) -> ProductWithExpireDate? {
      var products: ProductWithExpireDate = .init() // Initialize an empty dictionary to store the products with expiration dates
       // 5000-01-01 // - Fixme: ⚠️️ use distant future instead?
      let dateOf5000: Date = .init(timeIntervalSince1970: 95_617_584_000) // Create a date representing the year 5000
      // - Fixme: ⚠️️ use reduce instead?
      for (productID, productDateHelpers) in productDateDict { // Loop through each product ID and its corresponding product date helpers in the product date dictionary
         var date: Date = .init(timeIntervalSince1970: 0) // Initialize a date to store the latest valid date
         let lastCanceledDate: Date? = canceledProducts[productID] // Get the last canceled date for the product ID from the canceled products dictionary
         // - Fixme: ⚠️️ use filter?
         for productDateHelper: ProductDateHelper in productDateHelpers { // Loop through each product date helper for the product ID
            let validDate: Date = productDateHelper.getValidDate(lastCanceledDate: lastCanceledDate, unlimitedDate: dateOf5000) // Get the valid date for the product date helper
            if date.timeIntervalSince1970 < validDate.timeIntervalSince1970 { // Check if the valid date is later than the current latest valid date
               date = validDate // Update the latest valid date with the valid date
            }
         }
         products[productID] = date // Add the product ID and latest valid date to the products dictionary
      }
      return products.isEmpty ? nil : products // Return the products dictionary if it is not empty, otherwise return nil
   }
   /**
   * Converts a string representing a time interval in milliseconds to a date
   * - Fixme: ⚠️️ Consider moving this method to a Date extension
   * - Parameter str: A string representing a time interval in milliseconds
   * - Returns: A date representing the time interval in seconds, or nil if the input string is nil or cannot be converted to a time interval
   */
   private static func parseDate(_ str: String?) -> Date? {
      guard let str: String = str, let msTimeInterval: Double = TimeInterval(str) else { return nil } // Check if the input string is not nil and can be converted to a time interval in milliseconds, otherwise return nil
      return .init(timeIntervalSince1970: msTimeInterval / 1000) // Convert the time interval to seconds and initialize a date with the time interval
   }
}
