import Foundation
/**
 * Const
 */
extension RemoteReceiptValidator {
   /**
    * The default native location of the receipt.
    */
   public static let appStoreReceiptURL: URL? = Bundle.main.appStoreReceiptURL
   /**
    * Returns the server URL for the specified environment.
    * - Parameters:
    *    - isProduction: A boolean value indicating whether the server URL should be for the production environment.
    * - Returns: The server URL for the specified environment.
    * - Remark: This method is used in the `RemoteReceiptValidator` class to get the server URL for the specified environment. The method returns the server URL for the specified environment based on the value of the `isProduction` parameter.
    */
   public static func serverURL(isProduction: Bool?) -> String {
      isProduction == true // Check if the `isProduction` parameter is true
         ? VerifyReceiptURLType.production.rawValue // Return the production URL if `isProduction` is true
         : VerifyReceiptURLType.sandbox.rawValue // Return the sandbox URL if `isProduction` is false or nil
      }
}
/**
 * Type
 */
extension RemoteReceiptValidator {
   public typealias ValidityValue = (statusCode: Int, productWithExpireDate: ProductWithExpireDate, json: [String: Any]) // A tuple type that represents the validity value of a receipt
   public typealias ValidateHandler = (Result<ValidityValue, Error>) -> Void // A closure type that takes a result of a validity value or an error
   public typealias ProductWithExpireDate = [String: Date] // A dictionary type that maps product identifiers to expiration dates
   public typealias InAppPurchaseList = [[String: Any]] // An array type that contains dictionaries of in-app purchase information
   public typealias ProductDateDict = [String: [ProductDateHelper]] // A dictionary type that maps product identifiers to arrays of product date helpers
}
/**
 * URL
 */
extension RemoteReceiptValidator {
   /**
    * Validating receipt
    * Submit this JSON object as the payload of an HTTP POST request.
    * - Important: ⚠️️⚠️️⚠️️ Use the test environment URL https://sandbox.itunes.apple.com/verifyReceipt when testing your app in the sandbox and while your application is in review.
    * - Important: ⚠️️⚠️️⚠️️ Use the production URL https://buy.itunes.apple.com/verifyReceipt when your app is live in the App Store. For more information on these endpoints, see https://developer.apple.com/documentation/appstorereceipts/verifyreceipt
    * - Important: ⚠️️ First call AppleReceiptValidator with .production AppleReceiptValidator.VerifyReceiptURLType, if this fails (error), call exactly the same logic with .sandbox type.
    * - Important: ⚠️️ Note: The 21007 status code indicates that this receipt is a sandbox receipt,
    * - Remark: We must call prod URL first, the sandbox, as apple review uses sandbox to review your app etc
    * - Remark: When validating receipts on your server, your server needs to be able to handle a production-signed app getting its receipts from Apple’s test environment. The recommended approach is for your production server to always validate receipts against the production App Store first. If validation fails with the error code "Sandbox receipt used in production," you should validate against the test environment instead.
    * - Note: Production URL https://buy.itunes.apple.com/verifyReceipt
    * - Note: Sandbox URL https://sandbox.itunes.apple.com/verifyReceipt
    * https://github.com/bizz84/SwiftyStoreKit/blob/master/Sources/SwiftyStoreKit/AppleReceiptValidator.swift
    * https://developer.apple.com/library/ios/releasenotes/General/ValidateAppStoreReceipt/Chapters/ValidateRemotely.html
    */
   public enum VerifyReceiptURLType: String {
      case production = "https://buy.itunes.apple.com/verifyReceipt" // The production URL for verifying receipts
      case sandbox = "https://sandbox.itunes.apple.com/verifyReceipt" // The sandbox URL for verifying receipts
   }
}
// static let productionURL: String = "https://buy.itunes.apple.com/verifyReceipt"
// static let sandboxURL: String = "https://sandbox.itunes.apple.com/verifyReceipt"
