import Foundation
import UserDefaultSugar
@testable import AppStoreLib
/**
 * - Fixme: ⚠️️ Deprecate this? maybe nice to test things?
 * - Remark: Just reset user-default to delete purchases etc - Fixme: ⚠️️ maybe make a reset method in this class?
 * - Remark: We can use this class to model our IAP interface. So we get the right flow of things etc
 */
class DummyStore: IAPStoreKind {
   static let shared: DummyStore = .init()
   let appID: String = "co.company.appname"
   let sharedSecret: String = "MyApp"
   /**
    * Make purchase
    * // - Fixme: ⚠️️ dont ref inventory here. create another storage etc
    */
   func purchaseProduct(productID: String, onComplete: OnMakePurchaseComplete?) { // - Fixme: ⚠️️ add result and error etc
      guard let product: IAPProduct = Inventory.product(id: productID) else { onComplete?(.failure(NSError(domain: "Prod not found in inventory", code: 0))); return }
      setPurchase(product: product) // record purchase
      onComplete?(.success(productID))
   }
   /**
    * Validate purchase
    * - Fixme: ⚠️️ rename to validateReceipt or validatePurchases? why? keep as is!
    */
   func validatePurchase(productID: String, secret: String, onComplete: OnValidatePurchaseComplete?) {// - Fixme: ⚠️️ add result and error etc
      guard let purchase: IAPProduct = getPurchase(id: productID) else { onComplete?(.failure(NSError(domain: "Err", code: 0))); return }// retrive purchase
      // - Fixme: ⚠️️ add bellow and above
      onComplete?(.success((0, [purchase.id: Date.distantFuture], [:])))
   }
   /**
    * Get all purchases
    * - Fixme: ⚠️️ this is really getLocalPurchases etc? add purchaseIDS array in param?
    */
   func requestProducts(prodIDS: Set<String>, onComplete: OnProductsRequestComplete?) {
      let products = Purchases.model.purchases.keys.map { $0 }
      onComplete?(.success(products))
   }
}
/**
 * Interface with `user-default`
 * - Remark: Simulates interaction with AppStore connect etc
 */
extension DummyStore {
   private func setPurchase(product: IAPProduct) {
      guard let data: Data = try? product.encode() else { Swift.print("err, decode prodtype"); return } // Encode the product to data, log an error message if there is an error, and return if there is an error
         Purchases.model.purchases[product.id] = data // Set the purchases for the product ID to the encoded data
   }
   private func getPurchase(id: String) -> IAPProduct? {
      guard let product = Purchases.model.purchases[id] else { return nil } // Get the purchases for the given ID, return nil if there are no purchases
         return try? product.decode() // Decode the purchases to a product, return nil if there is an error
   }
}
/**
 * User default
 */
extension DummyStore {
   // - Fixme: ⚠️️ use Set<Data> ?
   // - Note: Alt name for purchases -> inventory
   struct Purchases: UserDefKind {
      static var defaultModel: Purchases { .init(purchases: [:]) } // Initialize a default model with an empty dictionary of purchases
         static var key: String { "purchases" } // Set the key for the purchases
         var purchases: [/*prodID*/String: /*product*/Data] // Define a dictionary of purchases with the product ID as the key and the product data as the value
   }
}
