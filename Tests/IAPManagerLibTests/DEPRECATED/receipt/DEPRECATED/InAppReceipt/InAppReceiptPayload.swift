import Foundation
import ASN1Swift

struct InAppReceiptPayload {
   let purchases: [InAppPurchase]
   let bundleIdentifier: String
   let appVersion: String
   let originalAppVersion: String
   let expirationDate: Date?
   let bundleIdentifierData: Data
   let opaqueValue: Data
   let receiptHash: Data
   let creationDate: Date
   let ageRating: String
   let environment: String
   let rawData: Data
   /**
    * Initialize a `InAppReceipt` passing all values
    - Parameters:
    - bundleIdentifier: The app’s bundle identifier
    - appVersion: The app’s version number
    - originalAppVersion: The version of the app that was originally purchased.
    - purchases: In-app purchase's receipts
    - expirationDate: The date that the app receipt expires
    - bundleIdentifierData: Used to validate the receipt
    - opaqueValue: An opaque value used, with other data, to compute the SHA-1 hash during validation.
    - receiptHash: A SHA-1 hash, used to validate the receipt.
    - creationDate: The date when the app receipt was created.
    - ageRating: Age Rating of the app
    - environment: Receipt's environment
    - rawData: Raw payload data
    */
   init(bundleIdentifier: String, appVersion: String, originalAppVersion: String, purchases: [InAppPurchase], expirationDate: Date?, bundleIdentifierData: Data, opaqueValue: Data, receiptHash: Data, creationDate: Date, ageRating: String, environment: String, rawData: Data) {
      self.bundleIdentifier = bundleIdentifier
      self.appVersion = appVersion
      self.originalAppVersion = originalAppVersion
      self.purchases = purchases
      self.expirationDate = expirationDate
      self.bundleIdentifierData = bundleIdentifierData
      self.opaqueValue = opaqueValue
      self.receiptHash = receiptHash
      self.creationDate = creationDate
      self.ageRating = ageRating
      self.environment = environment
      self.rawData = rawData
   }
}
