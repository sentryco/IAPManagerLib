import Foundation
import StoreKit
import Logger
/**
 * Transaction observer
 * - Description: We use `StoreObserver` as a way to react to changes that happens on other devices.
 * - Remark: Set `IAPStore.shared.addObserver()` in `appDidFinishLa...` and `IAPStore.shared.removeObserver()` in `appWillTermi...`
 */
extension IAPManager {
   /**
    * Store observer add
    * - Remark: We build the storeObserver into `IAPStore`. For easier API calls. rather than having `StoreObserver` in a seperate class etc
    * - Remark: If you want to detect the un-expected transactions. For example, your app requested a payment, but it crashed in that process. That transaction is not finished, and then will receive at next launch
    * - Fixme: ⚠️️ If doing `.count` to toggle observer doesn't work. roll back to internal `var observerAdded = false solution
    */
   public func beginObserving() {
      guard SKPaymentQueue.default().transactionObservers.count == 0 else { 
         Logger.warn("\(Trace.trace()) - only one observer")
         return 
      } // We only allow noe tx observer at the time ( Avoids adding store observer twice etc)
      SKPaymentQueue.default().add(self) // Begin monitor transactions
   }
   /**
    * Store observer remove
    */
   public func stopObserving() {
      guard SKPaymentQueue.default().transactionObservers.count > 0 else { 
         Logger.warn("\(Trace.trace()) - only one observer") 
         return 
      } // We only allow noe tx observer at the time ( Avoids adding store observer twice etc)
      SKPaymentQueue.default().remove(self) // Stop monitoring transactions
   }
}
