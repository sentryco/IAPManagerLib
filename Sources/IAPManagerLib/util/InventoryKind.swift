import Foundation

public protocol InventoryKind {
   /**
    * All products in inventory
    */
   static var allProducts: [IAPProduct] { get }
    /**
    * Returns the IAPProduct for the given product ID
    * - Parameter id: The product ID to search for
    * - Returns: The IAPProduct for the given product ID, or nil if the product ID is not found
    */
   static func product(productID: String) -> IAPProduct?
   /**
    * Providing localized names without going to the server (using `Purchase.localizedTitle` or similar) means you can provide the names of products without requiring a network load.
    * - Note: This tactic is recommended, although you probably want a slightly more sophisticated method than this simple switch statement. Loading the names of a pro subscription could reside in a Localizable.strings resource, for example.
    * - Fixme: ⚠️️ add localization later
    */
//   static func localizedDisplayName(for product: IAPProduct) -> String
}
