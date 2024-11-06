import Foundation
import UserDefaultSugar
@testable import IAPManagerLib
import JSONSugar
/**
 * - Fixme: ⚠️️ Deprecate this? maybe nice to test things?
 * - Remark: Just reset user-default to delete purchases etc - Fixme: ⚠️️ maybe make a reset method in this class?
 * - Remark: We can use this class to model our IAP interface. So we get the right flow of things etc
 */
class DummyStore: IAPStoreKind {
   static let shared: DummyStore = .init() // Initialize a shared instance of the DummyStore
   let appID: String = "co.company.appname" // Set the app ID for the DummyStore
   let sharedSecret: String = "MyApp" // Set the shared secret for the DummyStore
   /**
    * Make purchase
    * // - Fixme: ⚠️️ Don't ref inventory here. Create another storage etc
    */
   func purchaseProduct(productID: String, onComplete: OnPurchaseTransactionComplete?) { // - Fixme: ⚠️️ add result and error etc
      guard let product: IAPProduct = Inventory.product(productID: productID) else { onComplete?(.failure(NSError(domain: "Prod not found in inventory", code: 0))); return }
      setPurchase(product: product) // record purchase
      onComplete?(.success(productID))
   }
   /**
    * Validate purchase
    * - Note: Alt name: `validateReceipt` and `validatePurchases`
    */
   func validatePurchase(productID: String, secret: String, onComplete: OnRemotePurchaseValidationComplete?) {// - Fixme: ⚠️️ add result and error etc
      guard let purchase: IAPProduct = getPurchase(id: productID) else { onComplete?(.failure(NSError(domain: "Err", code: 0))); return }// retrive purchase
      // - Fixme: ⚠️️ add bellow and above
      onComplete?(.success((0, [purchase.id: Date.distantFuture], [:])))
   }
   /**
      * Get all local purchases for the given product IDs
      * - Parameter productIDs: An array of product IDs to filter the purchases by
      * - Remark: This method returns all purchases that have been made locally and have not been verified with the App Store
      */
   func requestProducts(prodIDS: Set<String>, onComplete: OnProductsRequestComplete?) {
      let products: [Dictionary<String, Data>.Keys.Element] = Purchases.model.purchases.keys.map { $0 }
      onComplete?(.success(products))
   }
}
/**
 * Interface with `user-default`
 * Simulates interaction with AppStore connect etc
 */
extension DummyStore {
   /**
    * Sets the purchase data for the specified `IAPProduct`.
    *
    * - Parameters:
    *    - product: The `IAPProduct` to set the purchase data for.
    *
    * - Returns: None.
    */
   private func setPurchase(product: IAPProduct) {
      guard let data: Data = try? product.encode() else {
         Swift.print("Err, decode prodtype")
         return
      }
      Purchases.model.purchases[product.id] = data
   }
   /**
    * Returns the `IAPProduct` with the specified ID, or `nil` if no product was found.
    * - Parameters:
    *    - id: The ID of the `IAPProduct` to retrieve.
    * - Returns: The `IAPProduct` with the specified ID, or `nil` if no product was found.
    */
   private func getPurchase(id: String) -> IAPProduct? {
      guard let product: Data = Purchases.model.purchases[id] else {
         return nil
      }
      return try? product.decode()
   }
}
/**
 * User default
 */
extension DummyStore {
   // - Fixme: ⚠️️ Use Set<Data> ?
   struct Purchases: UserDefKind {
      static var defaultModel: Purchases { .init(purchases: [:]) }
      // - Note: alt name: `inventory`
      static var key: String { "purchases" }
      var purchases: [/*prodID*/String: /*product*/Data] // model
   }
}
