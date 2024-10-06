import Foundation
import ASN1Swift
/**
 * https://github.com/tikhop/TPInAppReceipt/blob/master/Sources/InAppReceipt.swift
 * and - Fixme: ⚠️️ decode from payload?: https://github.com/tikhop/TPInAppReceipt/blob/master/Sources/InAppReceipt%2BASN1Decodable.swift
 * - Fixme: ⚠️️ add validation class: https://github.com/tikhop/TPInAppReceipt/blob/master/Sources/Validation.swift
 */
public final class InAppReceipt {
   /**
    * PKCS7 container
    */
   internal var receipt: _InAppReceipt
   /**
    * Payload of the receipt.
    * Payload object contains all meta information.
    */
   internal var payload: InAppReceiptPayload { receipt.payload }
   /**
    * root certificate path, used to check signature
    * added for testing purpose , as unit test can't read main bundle
    */
   internal var rootCertificatePath: String?
   /**
    * Raw data
    */
   private var rawData: Data
   /**
    * Initialize a `InAppReceipt` using local receipt
    */
   public convenience init() throws {
      let data = try Bundle.main.appStoreReceiptData()
      try self.init(receiptData: data)
   }
  /**
   * Initialize a `InAppReceipt` with asn1 payload
   * - parameter receiptData: `Data` object that represents receipt
   */
   public init(receiptData: Data, rootCertPath: String? = nil) throws {
      self.receipt = try _InAppReceipt(rawData: receiptData)
      self.rawData = receiptData
      #if DEBUG
      let certificateName: String = "StoreKitTestCertificate"
      #else
      let certificateName = "AppleIncRootCertificate"
      #endif
      self.rootCertificatePath = rootCertPath ?? Bundle.lookUp(forResource: certificateName, ofType: "cer")
   }
}

public extension InAppReceipt {
   /**
    * The app’s bundle identifier
    */
   var bundleIdentifier: String {
      payload.bundleIdentifier
   }
   /**
    * The app’s version number
    */
   var appVersion: String {
      payload.appVersion
   }
   /**
    * The version of the app that was originally purchased.
    */
   var originalAppVersion: String {
      payload.originalAppVersion
   }
   /**
    * In-app purchase's receipts
    */
   var purchases: [InAppPurchase] {
      payload.purchases
   }
   /**
    * Returns all auto renewable `InAppPurchase`s,
    */
   var autoRenewablePurchases: [InAppPurchase] {
      purchases.filter({ $0.isRenewableSubscription })
   }
   /**
    * Returns all ACTIVE auto renewable `InAppPurchase`s,
    */
   var activeAutoRenewableSubscriptionPurchases: [InAppPurchase] {
      purchases.filter({ $0.isRenewableSubscription && $0.isActiveAutoRenewableSubscription(forDate: Date()) })
   }
   /**
    * The date that the app receipt expires
    */
   var expirationDate: Date? {
      payload.expirationDate
   }
   /**
    * Returns `true` if any purchases exist, `false` otherwise
    */
   var hasPurchases: Bool {
      purchases.count > 0
   }
   /**
    * Returns `true` if any Active Auto Renewable purchases exist, `false` otherwise
    */
   var hasActiveAutoRenewablePurchases: Bool {
      activeAutoRenewableSubscriptionPurchases.count > 0
   }
   var creationDate: Date {
      payload.creationDate
   }
   var ageRating: String {
      payload.ageRating
   }
   /**
    * In App Receipt in base64
    */
   var base64: String {
      rawData.base64EncodedString()
   }
   /**
    * Return original transaction identifier if there is a purchase for a specific product identifier
    * - parameter productIdentifier: Product name
    */
   func originalTransactionIdentifier(ofProductIdentifier productIdentifier: String) -> String? {
      purchases(ofProductIdentifier: productIdentifier).first?.originalTransactionIdentifier
   }

   /**
    * Returns `true` if there is a purchase for a specific product identifier, `false` otherwise
    * - parameter productIdentifier: Product name
    */
   func containsPurchase(ofProductIdentifier productIdentifier: String) -> Bool {
      for item: InAppPurchase in purchases {
         if item.productIdentifier == productIdentifier {
            return true
         }
      }
      return false
   }
   /**
    * Returns `[InAppPurchase]` if there are purchases for a specific product identifier,
    * empty array otherwise
    * - parameter productIdentifier: Product name
    * - parameter sort: Sorting block
    */
   func purchases(ofProductIdentifier productIdentifier: String, sortedBy sort: ((InAppPurchase, InAppPurchase) -> Bool)? = nil) -> [InAppPurchase] {
      let filtered: [InAppPurchase] = purchases.filter({
         $0.productIdentifier == productIdentifier
      })
      typealias Sorter = ((InAppPurchase, InAppPurchase) -> Bool)
      if let sort: Sorter = sort {
         return filtered.sorted(by: {
            sort($0, $1)
         })
      } else {
         return filtered.sorted(by: {
            $0.purchaseDate > $1.purchaseDate
         })
      }
   }
   /**
    * Returns `InAppPurchase` if there is a purchase for a specific product identifier,
    * `nil` otherwise
    * - parameter productIdentifier: Product name
    */
   func activeAutoRenewableSubscriptionPurchases(ofProductIdentifier productIdentifier: String, forDate date: Date) -> InAppPurchase? {
      let filtered: [InAppPurchase] = purchases(ofProductIdentifier: productIdentifier)
      for purchase: InAppPurchase in filtered {
         if purchase.isActiveAutoRenewableSubscription(forDate: date) {
            return purchase
         }
      }
      return nil
   }
   /**
    * Returns the last `InAppPurchase` if there is one for a specific product identifier,
    * `nil` otherwise
    * - parameter productIdentifier: Product name
    */
   func lastAutoRenewableSubscriptionPurchase(ofProductIdentifier productIdentifier: String) -> InAppPurchase? {
      var purchase: InAppPurchase?
      let filtered: [InAppPurchase] = purchases(ofProductIdentifier: productIdentifier)
      var lastInterval: TimeInterval = 0
      for iap: InAppPurchase in filtered {
         if let thisInterval: TimeInterval = iap.subscriptionExpirationDate?.timeIntervalSince1970 {
            if purchase == nil || thisInterval > lastInterval {
               purchase = iap
               lastInterval = thisInterval
            }
         }
      }
      return purchase
   }
   /**
    * Returns true if there is an active subscription for a specific product identifier on the date specified,
    * false otherwise
    * - parameter productIdentifier: Product name
    * - parameter date: Date to check subscription against
    */
   func hasActiveAutoRenewableSubscription(ofProductIdentifier productIdentifier: String, forDate date: Date) -> Bool {
      activeAutoRenewableSubscriptionPurchases(ofProductIdentifier: productIdentifier, forDate: date) != nil
   }
}
/**
 * An extension to the `InAppReceipt` class that provides additional functionality.
 */
internal extension InAppReceipt {
   /**
    * The bundle identifier data for the receipt, used to validate the receipt.
    */
   var bundleIdentifierData: Data {
      payload.bundleIdentifierData
   }
   /**
    * An opaque value used, with other data, to compute the SHA-1 hash during validation.
    */
   var opaqueValue: Data {
      payload.opaqueValue
   }
   /**
    * A SHA-1 hash, used to validate the receipt.
    */
   var receiptHash: Data {
      payload.receiptHash
   }
}
/**
 * Extension for the `InAppReceipt` class.
 * - Remark: This extension provides computed properties for various data fields in the `InAppReceipt` class, including the signature, worldwide developer certificate data, iTunes certificate data, iTunes public key data, and payload raw data.
 */
public extension InAppReceipt {
   /// signature for validation
   var signature: Data? {
      receipt.signatureData
   }
   var worldwideDeveloperCertificateData: Data? {
      receipt.worldwideDeveloperCertificateData
   }
   var iTunesCertificateData: Data? {
      receipt.iTunesCertificateData
   }
   var iTunesPublicKeyData: Data? {
      receipt.iTunesPublicKeyData
   }
   var payloadRawData: Data {
      payload.rawData
   }
}
