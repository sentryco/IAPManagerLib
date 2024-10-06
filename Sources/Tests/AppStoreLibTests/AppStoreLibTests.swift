import StoreKit // Import the StoreKit framework
import XCTest // Import the XCTest framework
@testable import AppStoreLib // Import the AppStoreLib module for testing
import JSONSugar // Import the JSONSugar framework for testing

final class AppStoreLibTests: XCTestCase {
   // - Fixme: ⚠️️ clean up the tests etc
   func test() {
      do {
         // try Self.encodingTest() // Test the encoding and decoding of the product and subscription types
         try Self.testDummyStore() // Test the dummy store
         // try Self.testIAPStore() // Test the IAP store
      } catch { Swift.print("Error: \(error.localizedDescription)") }
   }
}
/**
 * TESTS
 */
extension AppStoreLibTests {
   /**
    * We test if product is purchased and valid, if not we prompt user to putchase
    * - Fixme: ⚠️️ Test restoring purchase etc
    * - Mock data source for available `Product`s in this demo app.
    * - Remark: Often, an app will not need anything more complicated than a simple provider like this.
    * - Remark: If your app uses a freemium business model, for example, your product model could vend `Product` instances alongside associated data about the upgrades to present in the user interface.
    */
   private static func testDummyStore() throws {
      // ⚠️️ We use UserDefaults to indicate that a user has purchased a product. In a real app, you’ll need to perform receipt validation and not save this indication locally.
      let productID: String = Inventory.monthlyExtendedSync.rawValue // Set the product ID to the monthly extended sync product ID
      let producIDS: Set<String> = [productID] // All of the possible products available in the app. This sequence will be passed to the `Merchant.register(...)` method.
      // First get product, so we know they are available
      DummyStore.shared.requestProducts(prodIDS: producIDS) { result in
         guard let products = try? result.get() as? [SKProduct],
               let product: SKProduct = products.first(where: { $0.productIdentifier == productID }) else { Swift.print("err: \(result.errorStr)"); return }
         // Engage to try paid feature -> check if product is purchased
         DummyStore.shared.validatePurchase(productID: product.productIdentifier, secret: "") { result in
            guard let val = try? result.get(), let expireDate: Date = val.productWithExpireDate[productID], // - Fixme: ⚠️️ do expiredate validation here etc?
                  ReceiptStatus.valid.rawValue == val.statusCode, // isValidReceipt
                  expireDate <= Date.now else { // hasNotExpired
               Swift.print("show pay for product: \(productID)"); return  // -> false -> prompt alert with purchase button // -> feature should proceed aka add more devices than 2
            }
            DummyStore.shared.purchaseProduct(productID: productID) { _ in // Purchase production alert -> engage apples payment sheet etc
               Swift.print("show feature: \(product.productIdentifier)") // -> feature should proceed aka add more devices than 2
            }
         }
      }
      // - Fixme: ⚠️️ add some StoreObserver calls
   }
   /**
    * Test sandbox-store
    * - Fixme: ⚠️️ add receipt validation to test?
    * - Fixme: ⚠️️ Store requested product in local userdefault, might have updated title, description etc
    */
   private static func testPurchase() throws {
      Swift.print("IAPUtil.testPurchase(): \(IAPUtil.canMakePayments())")
      IAPManager.shared.addObserver() // Remove observer when app close etc
      let prodID = Inventory.monthlyExtendedSync.rawValue
      // - Fixme: ⚠️️ add isProductValid, then prompt purchase or show product
      IAPManager.shared.requestProducts(prodIDS: [prodID]) { result in
         Swift.print("onProductsRequestComplete ✨")
         guard let products: [SKProduct] = try? result.get() as? [SKProduct] else { Swift.print("err: \(result.errorStr)"); return }
         products.forEach { Swift.print("ID: \(String(describing: $0.productIdentifier))") }
         // Prompt user to pick among products
         if let firstProduct: SKProduct = products.first {
            // Promt user to confirm correct product
            IAPManager.shared.purchaseProduct(productID: firstProduct.productIdentifier) { result in // purchase will automatically refresh local receipt
               Swift.print("onTransactionComplete ✨")
               guard let product: SKProduct = (try? result.get()) as? SKProduct else { Swift.print("Fail: \(result.errorStr)"); return }
               Swift.print("product.localizedTitle:  \(product.localizedTitle)")
               Swift.print("product.priceLocale:  \(product.priceLocale)")
               let formattedPrice: String? = IAPUtil.priceFormatter.string(from: product.price)
               Swift.print("formattedPrice: \(String(describing: formattedPrice))")
               Swift.print("purchased productIdentifier: \(String(describing: product.productIdentifier))")
               let isProductPurchased = LocalReceiptValidator.isProductPurchased(prodID: product.productIdentifier)
               Swift.print("isProductPurchased:  \(isProductPurchased)")
               let isSubscriptionActive = LocalReceiptValidator.isSubscriptionActive(prodID: product.productIdentifier)
               Swift.print("isSubscriptionActive:  \(isSubscriptionActive)")
            }
         }
      }
   }
   /**
    * Test display products
    * - Fixme: ⚠️️ continue to research some more, just to wrap things up etc
    */
   private static func testDispalyProducts() {
      Swift.print("testDispalyProducts")
      Inventory.allProducts.forEach { Swift.print("$0.isActive: \($0.isActive)") } // build an array of products that can be used in a table, get title, price, description from inventory (StoreKit also has this, but that requires internet)get valid state for products (via local receipt)
   }
   /**
    * Test local validating receipt
    * - Remark: Validate on app start. and when trying to access feature
    * - Note: Ref: https://gist.githubusercontent.com/RenGate/974c57086e59e58dc234c4c621f26738/raw/bc6b410a0df8640e5db44e3b2731ce38c0f59b3c/article2.readReceipt.swift
    *  - Fixme: ⚠️️ Check network access etc, if there is internet, always refresh
    * - Description: Assert access to feature by checking for local valid receipt
    */
   private static func testReadLocalReceipt() {
      Swift.print("testReadLocalReceipt")
      LocalReceiptValidator.getPurchases(refresh: false) { result in
         guard let purchases = try? result.get() else { Swift.print("Err: \(result.errorStr)"); return } // Use StoreKit to request a new receipt
         let hasValidMonthlySubscription: Bool = purchases.activeAutoRenewableSubscription.contains { // monthly renewable
            $0.productIdentifier == Inventory.monthlyExtendedSync.rawValue
         }
         let hasValidLifeTimePurchase: Bool = purchases.nonConsumable.contains { // lifetime nonConsumable
            $0.productIdentifier == Inventory.lifeTimeExtendedSync.rawValue
         }
         let isEligableForFeature: Bool = hasValidMonthlySubscription || hasValidLifeTimePurchase
         Swift.print("isEligableForFeature: \(isEligableForFeature ? "✅" : "🚫")") // Enable a feature of your app
      }
   }
   /**
    * Test remote validating receipt
    */
   private static func testRemoteReceiptValidation() {
      // - Fixme: ⚠️️ continue? 🚫 maybe we don't need this, since local receipt can be refreshed from remote etc?
   }
}
/**
 * Other tests
 */
extension AppStoreLibTests {
   /**
    * Test
    */
   private static func encodingTest() throws {
      // 1
      let product1: ProductKind = IAPMonthlySubProduct(id: "co.company.product1", startDate: .now, durationInMonths: 1)
      let data1: Data? = try? ProductType.data(rawValue: product1)
      Swift.print("data?.count:  \(String(describing: data1?.count))")
      let cloneOfProd1: ProductKind? = try? ProductType.decode(data: data1)
      Swift.print("cloneOfProd1?.id: \(String(describing: cloneOfProd1?.id))")
      Swift.print("cloneOfProd1?.startDate:  \(String(describing: (cloneOfProd1 as? IAPMonthlySubProduct)?.startDate))")
      Swift.print("cloneOfProd1?.expirationDta:  \(String(describing: (cloneOfProd1 as? IAPMonthlySubProduct)?.expirationDate))")
      Swift.print("cloneOfProd1?.isValid:  \(String(describing: cloneOfProd1?.isValid))")
      // 2
      let product2: ProductKind = IAPNonConsumable(id: "co.company.product2", isValid: true)
      let data2 = try? ProductType.data(rawValue: product2)
      let cloneOfProd2 = try? ProductType.decode(data: data2)
      Swift.print("cloneOfProd2?.id:  \(String(describing: cloneOfProd2?.id))")
      Swift.print("cloneOfProd2?.isValid:  \(String(describing: cloneOfProd2?.isValid))")
      // - Fixme: ⚠️️ Store product in UserDefault, see notes, see unittest+userdef etc
   }
}
/**
 * Customize store config in your own app with the bellow:
 * - Fixme: ⚠️️ we could make this overridable and print error if not setup etc?
 */
extension IAPManager {
   static let shared = IAPManager.sharedInstance(appID: "co.company.app", sharedSecret: "MyApp")
}
/**
 * - Fixme: ⚠️️ use this to debug when validating receipt
 */
// - Fixme: ⚠️️ remove soon?
//func printValidation() {
//   var productString = ""
//   if let products = products {
//      for (productID, _) in products {
//         productString += productID + " "
//      }
//   }
//   self.resultString = "\(statusCode ?? -999): \(productString)"
//}
