import Foundation
import StoreKit
/**
 * - Description: This protocol defines the properties of a payment transaction, including the transaction date, state, and identifier.
 * DEPRECATED ⚠️️
 */
public protocol PaymentTransaction {
   var transactionDate: Date? { get }
   var transactionState: SKPaymentTransactionState { get }
   var transactionIdentifier: String? { get }
   // var downloads: [SKDownload] { get }
}
/// Products information
//public struct RetrieveResults {
//   public let retrievedProducts: Set<SKProduct>
//   public let invalidProductIDs: Set<String>
//   public let error: Error?
//   
//   public init(retrievedProducts: Set<SKProduct>, invalidProductIDs: Set<String>, error: Error?) {
//      self.retrievedProducts = retrievedProducts
//      self.invalidProductIDs = invalidProductIDs
//      self.error = error
//   }
//}
