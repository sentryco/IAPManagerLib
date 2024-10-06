import Foundation
@testable import AppStoreLib
/**
 * Our product offering
 * - Description: Product database
 * - Fixme: ⚠️️ this should be in the test scope. not in the library etc
 */
enum Inventory: String, CaseIterable, InventoryKind {
   // - Fixme: ⚠️️ Constants.AppBundleIdentifier + ".free", ".plus1y" ".pro1y",
   // 2.99 per month
   case monthlyExtendedSync = "co.company.appName.monthly-extended-sync"
   // buy the app for life 19.99$
   case lifeTimeExtendedSync = "co.company.appName.lifeTime-extended-sync"
//   let monthlySubID = "MyApp.sub.allaccess.monthly"
//   let yearlySubID = "MyApp.sub.allaccess.yearly"
}
extension Inventory {
   /**
    * Returns IAPProduct for id
    */
   static func product(id: String) -> IAPProduct? {
      switch Inventory(rawValue: id) { // Switch on the Inventory with the given ID
         case .monthlyExtendedSync: return Inventory.monthlyExtendedSyncProduct // Return the monthly extended sync product if the Inventory is monthlyExtendedSync
         case .lifeTimeExtendedSync: return Inventory.lifeTimeExtendedSyncProduct // Return the lifetime extended sync product if the Inventory is lifeTimeExtendedSync
         default: return nil // Return nil if the Inventory is not recognized
         }
   }
   /**
    * All products in inventory
    */
   static var allProducts: [IAPProduct] {
      Inventory.allCases.compactMap { Inventory.product(id: $0.id) } // Get all the products for the Inventory cases and remove any nil values
   }
}
/**
 * Our products
 */
extension Inventory {
   fileprivate static let monthlyExtendedSyncProduct: IAPProduct = {
      .init(id: Inventory.monthlyExtendedSync.id,
            type: .autoRenewable,
            title: "App subscription required",
            description: "Syncing more than 2 devices requires a subscription plan. For $2.99 a month you can sync up to 8 devices. The subscription is valid for all other iOS and macOS devices attached to your apple-id.",
            price: Double(2.99)
      )
   }()
   fileprivate static let lifeTimeExtendedSyncProduct: IAPProduct = {
      .init(id: Inventory.lifeTimeExtendedSync.id,
            type: .nonConsumable,
            title: "App subscription required",
            description: "Syncing more than 2 devices requires an in-app-subscription. You will be able to sync up to 8 devices. The subscription is valid for all other iOS and macOS devices attached to your apple-id.",
            price: Double(19.99)
      )
   }()
}
extension Inventory {
   /**
    * Providing localized names without going to the server (using `Purchase.localizedTitle` or similar) means you can provide the names of products without requiring a network load.
    * - Remark: This tactic is recommended, although you probably want a slightly more sophisticated method than this simple switch statement. Loading the names of a pro subscription could reside in a Localizable.strings resource, for example.
    */
   public static func localizedDisplayName(for product: IAPProduct) -> String {
      switch product.id {
      case Inventory.monthlyExtendedSync.rawValue: return "A Product" // Return the localized name for the monthly extended sync product
      case Inventory.lifeTimeExtendedSync.rawValue: return "Another Product" // Return the localized name for the lifetime extended sync product
      default: fatalError("unknown product, localized name not available") // Log a fatal error if the product ID is not recognized
      }
   }
}




// - Fixme: ⚠️️  we should do localization here as well? https://github.com/atjason/IAPHelper/blob/master/IAPDemo/IAPDemo/IAP/Account.swift
//
//
//static let Free = AccountType(productIdentifier: Constants.AppBundleIdentifier + ".free",
//                              localizedTitle: NSLocalizedString("IAP Free", comment: "Account"),
//                              localizedTitleSuffix: "")
//
//static let Plus1Y = AccountType(productIdentifier: Constants.AppBundleIdentifier + ".plus1y",
//                                localizedTitle: NSLocalizedString("IAP Plus", comment: "Account"),
//                                localizedTitleSuffix: NSLocalizedString(" / year", comment: "Account"))
//
//static let Pro1Y = AccountType(productIdentifier: Constants.AppBundleIdentifier + ".pro1y",
//                               localizedTitle: NSLocalizedString("IAP Pro", comment: "Account"),
//                               localizedTitleSuffix: NSLocalizedString(" / year", comment: "Account"))
//}
