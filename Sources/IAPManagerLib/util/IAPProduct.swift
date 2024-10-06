import Foundation
import TPInAppReceipt
import StoreKit
import Logger
/**
 * - Description: Used as a local storage for info regarding IAP products
 * - Remark: This info can also be gained from apple connect etc, but more convenient to store it locally
 * - Fixme: ⚠️️ Maybe populate user-default from apple connect the first time, then use local userdefault as store etc? that way we could change title, description etc from the itunes connect dashboard
 * - Fixme: ⚠️️ Possibly also add IAPSubscriptionGroup? for what?
 */
public struct IAPProduct: Codable {
   public let id: String // productID
   public let type: IAPProductType
   public let title: String
   public let description: String
   public let price: Double // Dollar
   /**
    * Initializes an `IAPProduct` object with the given parameters.
    *
    * - Parameters:
    *   - id: The ID of the product.
    *   - type: The type of the product.
    *   - title: The title of the product.
    *   - description: The description of the product.
    *   - price: The price of the product.
    *
    * - Fixme: ⚠️️ We will have to pull price from app-store to get it correctly localized etc.
    */
   public init(id: String, type: IAPProduct.IAPProductType, title: String, description: String, price: Double) {
      self.id = id
      self.type = type
      self.title = title
      self.description = description
      self.price = price
   }
}
/**
 * Getter
 */
extension IAPProduct {
   /**
      * Returns the localized price of the product as a string
      * - Fixme: ⚠️️ Rename to getLocalizedPrice
      * - Fixme: ⚠️️ Add support for locale in parameter
      * - Returns: The localized price of the product as a string, or the product price as a string if the localized price cannot be obtained
      */
   public var localizedPrice: String {
      let price: NSDecimalNumber = .init(value: self.price) // Initialize a decimal number with the product price
         // Swift.print("IAPProduct.localizedPrice - price:  \(price)")
         let curLocale: Locale = .usLocale // .current // Set the current locale to US
         // Swift.print("IAPProduct.localizedPrice - curLocale: \(curLocale)")
         let localizedPrice: String? = SKProduct.getLocalizedPrice(price: price, locale: curLocale) // Get the localized price for the product price and current locale
         // Swift.print("IAPProduct.localizedPrice:  \(String(describing: localizedPrice))")
         return localizedPrice ?? "\(self.price)" // Return the localized price if it is not nil, otherwise return the product price as a string
   }
   /**
    * Returns the product title and localized price as a string
    * - Returns: The product title and localized price as a string
    */
   public var titleAndPrice: String {
      self.title + " " + "(\(self.localizedPrice))" // Concatenate the product title and localized price to form a string
   }
}
/**
 * Type
 */
extension IAPProduct {
   /**
      * A dictionary of product identifiers and their corresponding IAP products
      * - Fixme: ⚠️️ Consider moving this dictionary to its own scope
      */
   public enum IAPProductType: Codable {
      case nonConsumable // Type that customers purchase once. They don't expire.
      case autoRenewable // Type that customers purchase and it provides access over a limited duration and don't renew automatically. Customers can purchase them again. (automatically renewing subscriptions must be tested on device. i think)
      case nonRenewable // Type that customers purchase once and that renew automatically on a recurring basis until customers decide to cancel.
      case consumable // Type that are depleted after one use. Customers can purchase them multiple times.
   }
}
/**
 * Assert
 */
extension IAPProduct {
   /**
    * Determines if a product has been purchased and is still valid
    * - Remark: We can call `InAppReceipt.refresh()` to get a refreshed receipt from apple. We can do this at applaunch and viewController willApear etc.
    * - Fixme: ⚠️️ Use the other method in receipt that directly quiery the id for acti e etc. same with nonCOnsumable
    * - Fixme: ⚠️️ Make this a method that throws? 👈 getActiveState? or getIsActive or getActive? or getValid?
    */
   public var isActive: Bool {
      do {
         let localReceipt: InAppReceipt = try InAppReceipt.localReceipt() // Initialize receipt
         // Swift.print("receipt.bundleIdentifier: \(receipt.bundleIdentifier)")
         try localReceipt.validate() // Local validation
         switch type {
            case .autoRenewable: return LocalReceiptValidator.isSubscriptionActive(prodID: self.id) // Check if the subscription is active for the product ID
            case .nonConsumable: return LocalReceiptValidator.isProductPurchased(prodID: self.id) // Check if the product is purchased for the product ID
            default: fatalError("type not supported: \(type)") // Throw a fatal error if the product type is not supported
         }
      } catch {
         Logger.error("\(Trace.trace()) - Err: \(error)")
         return false
      }
   }
}
/**
 * Temp fix ⚠️️
 * - Remark: Has some nice conversion code: https://medium.com/@mariannM/currency-converter-in-swift-4-2-97384a56da41
 */
extension Locale {
   static let usLocale: Locale = .init(identifier: "en_US") // Initialize a US locale
//   static let frenchLocale = Locale(identifier: "fr_FR")
//   static let germanLocale = Locale(identifier: "de_DE")
//   static let hungarianLocale = Locale(identifier: "hu_HU")
//   static let hungarianLocale = Locale(identifier: "it_IT")
}
