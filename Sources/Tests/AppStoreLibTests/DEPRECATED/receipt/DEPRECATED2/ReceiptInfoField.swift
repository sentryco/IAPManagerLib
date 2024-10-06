import Foundation
import StoreKit

// Receipt field as defined in : https://developer.apple.com/library/ios/releasenotes/General/ValidateAppStoreReceipt/Chapters/ReceiptFields.html#//apple_ref/doc/uid/TP40010573-CH106-SW1
public enum ReceiptInfoField: String {
   /// Bundle Identifier. This corresponds to the value of CFBundleIdentifier in the Info.plist file.
   case bundle_id
   /// The app’s version number.This corresponds to the value of CFBundleVersion (in iOS) or CFBundleShortVersionString (in OS X) in the Info.plist.
   case application_version
   /// The version of the app that was originally purchased. This corresponds to the value of CFBundleVersion (in iOS) or CFBundleShortVersionString (in OS X) in the Info.plist file when the purchase was originally made.
   case original_application_version
   /// The date when the app receipt was created.
   case creation_date
   /// The date that the app receipt expires. This key is present only for apps purchased through the Volume Purchase Program.
   case expiration_date

   /// The receipt for an in-app purchase.
   case in_app

   public enum InApp: String {
      /// The number of items purchased. This value corresponds to the quantity property of the SKPayment object stored in the transaction’s payment property.
      case quantity
      /// The product identifier of the item that was purchased. This value corresponds to the productIdentifier property of the SKPayment object stored in the transaction’s payment property.
      case product_id
      /// The transaction identifier of the item that was purchased. This value corresponds to the transaction’s transactionIdentifier property.
      case transaction_id
      /// For a transaction that restores a previous transaction, the transaction identifier of the original transaction. Otherwise, identical to the transaction identifier. This value corresponds to the original transaction’s transactionIdentifier property. All receipts in a chain of renewals for an auto-renewable subscription have the same value for this field.
      case original_transaction_id
      /// The date and time that the item was purchased. This value corresponds to the transaction’s transactionDate property.
      case purchase_date
      /// For a transaction that restores a previous transaction, the date of the original transaction. This value corresponds to the original transaction’s transactionDate property. In an auto-renewable subscription receipt, this indicates the beginning of the subscription period, even if the subscription has been renewed.
      case original_purchase_date
      /// The expiration date for the subscription, expressed as the number of milliseconds since January 1, 1970, 00:00:00 GMT. This key is only present for auto-renewable subscription receipts.
      case expires_date
      /// For a transaction that was canceled by Apple customer support, the time and date of the cancellation. Treat a canceled receipt the same as if no purchase had ever been made.
      case cancellation_date
      #if os(iOS) || os(tvOS)
      /// A string that the App Store uses to uniquely identify the application that created the transaction. If your server supports multiple applications, you can use this value to differentiate between them. Apps are assigned an identifier only in the production environment, so this key is not present for receipts created in the test environment. This field is not present for Mac apps. See also Bundle Identifier.
      case app_item_id
      #endif
      /// An arbitrary number that uniquely identifies a revision of your application. This key is not present for receipts created in the test environment.
      case version_external_identifier
      /// The primary key for identifying subscription purchases.
      case web_order_line_item_id
   }
}

#if os(OSX)
public enum ReceiptExitCode: Int32 {
   /// If validation fails in OS X, call exit with a status of 173. This exit status notifies the system that your application has determined that its receipt is invalid. At this point, the system attempts to obtain a valid receipt and may prompt for the user’s iTunes credentials
   case notValid = 173
}
#endif
