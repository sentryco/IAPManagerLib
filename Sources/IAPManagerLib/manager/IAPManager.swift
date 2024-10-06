import Foundation
import StoreKit
import Logger
/**
 * Has to be `NSObject` or else `SKProductsRequestDelegate` won't work etc
 * - Note: More product requests: https://github.com/bizz84/SwiftyStoreKit/blob/master/Sources/SwiftyStoreKit/InAppProductQueryRequest.swift
 * - Note: More store commands: https://github.com/bizz84/SwiftyStoreKit/blob/master/Sources/SwiftyStoreKit/SwiftyStoreKit.swift
 * - Fixme: ⚠️️ Potentially add productionstore urls in init
 * - Fixme: ⚠️️ Add `onEntitlementRevocation`
 * fix: move to own repo on github with own tests etc, when compute and mem allows
 */
public final class IAPManager: NSObject, IAPStoreKind {
   public let appID: String
   /**
    * Callback after products are fetched
    */
   public var onProductsRequestComplete: OnProductsRequestComplete?
   /**
    * Callback when transaction completed
    */
   public var onPurchaseTransactionComplete: OnPurchaseTransactionComplete?
   /**
    * Callback when restore completed
    */
   public var onPurchaseRestored: OnPurchaseRestored?
   /**
    * Callback when validating
    * - Fixme: ⚠️️⚠️️⚠️️ Move out of `IAPManager` scope? use remote-validtor directly etc?
    */
   public var onValidatePurchaseComplete: OnRemotePurchaseValidationComplete?
   /**
    * Seems we have to make a strong ref to productrequest or it will become buggy in macos: https://stackoverflow.com/questions/60921039/universal-in-app-purchase-on-ios-and-macos
    */
   public var productRequest: SKProductsRequest? // Used when requesting products from remote apple server
   /**
    * Initializes a new instance of `IAPManager` with the given app ID.
    * - Parameter appID: The app ID to use for the `IAPManager`.
    */
   public init(appID: String) {
      Logger.debug("\(Trace.trace()) - appID:  \(appID)", tag: .other) // Log a debug message with the app ID
      self.appID = appID // Set the app ID for the `IAPManager`
   }
}
