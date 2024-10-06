import Foundation
import StoreKit
/**
 * Const - singleton
 * - Remark: Add your own static shared letin an extension in your own code etc
 */
extension IAPManager {
   // One source of truth
   private static var _shared: IAPManager?
   /**
    * Returns a shared instance of `IAPManager` with the given app ID.
    * - Note: Use this method directly if the shared instance needs to be customized. Call it only once in the beginning of the code, and use regular `.shared` in subsequent calls.
    * - Remark: Reference this in the code before `.shared` is referenced, or it won't work.
    * - Parameter appID: The app ID to use for the shared instance.
    * - Returns: A shared instance of `IAPManager` with the given app ID.
    */
   public static func sharedInstance(appID: String/*, sharedSecret: String*/) -> IAPManager {
      guard let shared: IAPManager = _shared else { // Check if the shared instance is nil (first run)
         let shared: IAPManager = .init(appID: appID) // Create a new instance of `IAPManager` with the given app ID ( // Temp variable)
         _shared = shared // Set the shared instance to the new instance (Set permanent variable)
         return shared // Return the new instance
      }
      return shared // Instance already exist, return instance
   }
}
