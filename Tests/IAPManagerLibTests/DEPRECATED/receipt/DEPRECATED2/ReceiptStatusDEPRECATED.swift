import Foundation
import StoreKit
/// Status code returned by remote server
///
/// See Table 2-1  Status codes
//public enum ReceiptStatus: Int {
//   /// Not decodable status
//   case unknown = -2
//   /// No status returned
//   case none = -1
//   /// valid statua
//   case valid = 0
//   /// The App Store could not read the JSON object you provided.
//   case jsonNotReadable = 21000
//   /// The data in the receipt-data property was malformed or missing.
//   case malformedOrMissingData = 21002
//   /// The receipt could not be authenticated.
//   case receiptCouldNotBeAuthenticated = 21003
//   /// The shared secret you provided does not match the shared secret on file for your account.
//   case secretNotMatching = 21004
//   /// The receipt server is not currently available.
//   case receiptServerUnavailable = 21005
//   /// This receipt is valid but the subscription has expired. When this status code is returned to your server, the receipt data is also decoded and returned as part of the response.
//   case subscriptionExpired = 21006
//   ///  This receipt is from the test environment, but it was sent to the production environment for verification. Send it to the test environment instead.
//   case testReceipt = 21007
//   /// This receipt is from the production environment, but it was sent to the test environment for verification. Send it to the production environment instead.
//   case productionEnvironment = 21008
//   
//   var isValid: Bool { return self == .valid}
//}
