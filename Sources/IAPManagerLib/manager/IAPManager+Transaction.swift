import Foundation
import StoreKit
import Logger
/**
 * Transaction delegate
 * - Remark: Silently manage purchases that happens outside of direct user interaction
 * - Remark: Transactions can happen outside your App. Say your user changes their subscription type in the system settings, or your deferred transaction was approved by the user’s parents, you won’t be able to tell unless you are expecting them. For that reason, always, in the `AppDelegate`, at the start of your app, subscribe the app to the PaymentQueue. This way you will make sure you won’t miss any event.
 * - Note: More code: https://github.com/bizz84/SwiftyStoreKit/blob/master/Sources/SwiftyStoreKit/CompleteTransactionsController.swift
 * - Note: More advance: https://github.com/bizz84/SwiftyStoreKit/blob/master/Sources/SwiftyStoreKit/PaymentQueueController.swift
 * - Fixme: ⚠️️ We removed setting callbacks to nil, the listener should do this if needed, I think
 */
extension IAPManager: SKPaymentTransactionObserver {
   /**
      * This method is called when the payment queue updates the transaction status.
      * To make this method work, you need to add `SKPaymentQueue.default().add(StoreObserver.shared)` to `didFinishLaunchingWithOptions` in the app delegate.
      * - Parameters:
      *   - queue: The payment queue that updated the transaction status.
      *   - transactions: An array of payment transactions that were updated.
      */
   public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
      processTransactions(transactions: transactions) // Call the `processTransactions` method with the given transactions
   }
   /**
      * Process transactions
      * - Remark: This method is called from the `paymentQueue(_:updatedTransactions:)` method in the `StoreObserver` class.
      * - Parameter transactions: An array of payment transactions to process.
      */
   private func processTransactions(transactions: [SKPaymentTransaction]) {
      for transaction: SKPaymentTransaction in transactions {
         switch transaction.transactionState {
         case .failed: failed(transaction: transaction) // Call the `failed` method with the given transaction
         case .purchased: purchased(transaction: transaction) // Call the `purchased` method with the given transaction
         case .restored: restored(transaction: transaction) // Call the `restored` method with the given transaction
         case .deferred, .purchasing: // Do nothing
            Logger.debug("\(Trace.trace()) -  Transaction deferred or purchasing - prod id: \(transaction.payment.productIdentifier)")
         @unknown default:
            Swift.print("⚠️️ unkown case")
         }
      }
   }
}
/**
 * Events
 */
extension IAPManager {
   /**
      * This method is called when a transaction is restored.
      * - Parameter transaction: The restored transaction.
      * - Fixme: ⚠️️ What should we do with the restored transaction?
      */
   private func restored(transaction: SKPaymentTransaction) {
      Logger.debug("\(Trace.trace()) - transaction.payment.productIdentifier: \(transaction.payment.productIdentifier)") // Log a debug message indicating the product identifier of the transaction payment
      onPurchaseRestored?(.success([transaction.payment.productIdentifier])) // Call the `onPurchaseRestored` completion handler with a success result and an array containing the product identifier of the restored transaction
      // onPurchaseRestored = nil
      finishTransaction(transaction) // Finish the given transaction
   }
   /**
      * This method is called when a transaction is completed (purchased).
      * - Fixme: ⚠️️ Is this called if the transaction happens on another OS platform as well?
      * - Parameter transaction: The completed transaction.
      */
   private func purchased(transaction: SKPaymentTransaction) {
      Logger.debug("\(Trace.trace()) - prodID: \(transaction.payment.productIdentifier) and transaction.original?.payment.productIdentifier:  \(String(describing: transaction.original?.payment.productIdentifier))") // Log a debug message indicating the product identifier of the transaction payment and the original transaction payment, if any
      onPurchaseTransactionComplete?(.success(transaction.payment.productIdentifier)) // onTransactionComplete?(transaction.payment.productIdentifier, transaction.error)
      // onPurchaseTransactionComplete = nil // Reset (should only happen once)
      finishTransaction(transaction) // This is an opertunity to make sure content was delivered before giving the final goahead of the purchase, I think
   }
   /**
      * This method is called when a transaction fails during purchase or restore.
      * - Remark: Both purchase and restore may come to this state. So need to deal with both handlers.
      * - Parameter transaction: The failed transaction.
      * - Fixme: ⚠️️ What should we do when a transaction fails?
      */
   private func failed(transaction: SKPaymentTransaction) {
      Logger.debug("\(Trace.trace()) - prodID: \(transaction.payment.productIdentifier)") // Log a debug message indicating the product identifier of the transaction payment
      if let transactionError: NSError = transaction.error as NSError?, // Check if there is an error in the transaction
         let localizedDescription: String = transaction.error?.localizedDescription, // Get the localized description of the error
         transactionError.code != SKError.paymentCancelled.rawValue { // Check if the error code is not paymentCancelled
         Logger.error("\(Trace.trace()) - Transaction Error: \(localizedDescription)") // Log an error message indicating the localized description of the error
         // Only post the fail notification if the error isn't user cancel (ie. user tap 'Cancel' on the payment prompt dialog)
         onPurchaseTransactionComplete?(.failure(transactionError)) // Call the `onPurchaseTransactionComplete` completion handler with a failure result and the transaction error
      }
       // - Fixme: ⚠️️ diff user vs server fail
      onPurchaseTransactionComplete?(.failure(NSError(domain: "TX failed, payment Cancelled by user", code: 0))) // Call the `onPurchaseTransactionComplete` completion handler with a failure result and an error indicating that the payment was cancelled by the user //("tx failed")
      // onPurchaseTransactionComplete = nil // Reset
      // - Fixme: ⚠️️ pass error aswell
      onPurchaseRestored?(.failure(NSError(domain: "TX failed", code: 0))) // Call the `onPurchaseRestored` completion handler with a failure result and an error indicating that the transaction failed
      // onPurchaseRestored = nil // Reset
      finishTransaction(transaction) // Finish the given transaction
   }
}
/**
 * Delegates
 */
extension IAPManager {
   /**
   * This method is called when the payment queue has finished processing transactions.
   * - Fixme: ⚠️️ When are these called?
   * - Parameter queue: The payment queue that finished processing transactions.
   * - Remark: This method is called after the `paymentQueue(_:updatedTransactions:)` method has been called for all updated transactions.
   */
   public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
      Logger.debug("\(Trace.trace())")
      // completeRestoreTransactions(queue, error: nil)
      processTransactions(transactions: queue.transactions)
   }
   /**
      * This method is called when the payment queue has finished restoring completed transactions.
      * - Fixme: ⚠️️ When are these called?
      * - Parameters:
      *   - queue: The payment queue that finished restoring completed transactions.
      *   - error: An error that occurred while restoring completed transactions, if any.
      * - Remark: This method is called after all transactions have been restored by the payment queue.
      */
   public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
      Logger.debug("\(Trace.trace()) - restoreCompletedTransactionsFailedWithError") // Log a debug message indicating that restoring completed transactions failed with an error
      // completeRestoreTransactions(queue, error: error)
      // - Fixme: ⚠️️ Call something here?
   }
}
/**
 * Helper
 */
extension IAPManager {
   /**
      * This method is called when a transaction is finished.
      * - Fixme: ⚠️️ Add callback here? maybe not?
      * - Parameter transaction: The finished transaction.
      * - Remark: This method is called after the `paymentQueue(_:updatedTransactions:)` method has been called for the transaction.
      */
   private func finishTransaction(_ transaction: SKPaymentTransaction) {
      Logger.debug("\(Trace.trace()) - prodID: \(transaction.payment.productIdentifier)") // Log a debug message indicating the product identifier of the transaction payment
      switch transaction.transactionState {
      case SKPaymentTransactionState.purchased,
           SKPaymentTransactionState.restored,
           SKPaymentTransactionState.failed: // Check if the transaction state is purchased, restored, or failed
         SKPaymentQueue.default().finishTransaction(transaction) // Finish the given transaction
      default: break // Do nothing for other transaction states
      }
   }
}
/// Restore purchase results
// public struct RestoreResults {
//   public let restoredPurchases: [Purchase]
//   public let restoreFailedPurchases: [(SKError, String?)]
//
//   public init(restoredPurchases: [Purchase], restoreFailedPurchases: [(SKError, String?)]) {
//      self.restoredPurchases = restoredPurchases
//      self.restoreFailedPurchases = restoreFailedPurchases
//   }
//}
//   private func deliverPurchaseNotificationFor(identifier: String?) {
//      guard let identifier = identifier else { return }
//
////      purchasedProductIdentifiers.insert(identifier)
////      UserDefaults.standard.set(true, forKey: identifier)
////      NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: identifier)
//   }
// var productIdentifiers = Set<ProductIdentifier>()
// for transaction in SKPaymentQueue.default().transactions {
//    if let productIdentifier = transaction.original?.payment.productIdentifier {
//       productIdentifiers.insert(productIdentifier)
//    }
//    finishTransaction(transaction)
// }
