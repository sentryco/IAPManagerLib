import Foundation

protocol ReceiptValidatorKind {
//   func isSubscriptionActive(forExpiryDate expiryDate: Date)
//   static func validateReceipt(isProduction: Bool?, password: String?, onComplete: ValidateHandler?)
//   static func parseValidateResultJSON(_ json: [String: Any]?) -> ProductWithExpireDate?
//   static func receiptRequestData(_ appStoreReceiptURL: URL?, password: String?) -> Data?
//   static func productDateDictAndCanceledProducts(totalInAppPurchaseList: InAppPurchaseList) -> (ProductDateDict, ProductWithExpireDate)
//   static func products(productDateDict: [String: [ProductDateHelper]], canceledProducts: ProductWithExpireDate) -> ProductWithExpireDate?
}
/**
 * Const - type
 */
extension ReceiptValidatorKind {
   // - Fixme: ⚠️️ use Result
//   typealias ValidityValue = (statusCode: Int, productWithExpireDate: ProductWithExpireDate, json: [String: Any])
//   typealias ValidateHandler = (Result<ValidityValue, Error>) -> Void
//   typealias ProductWithExpireDate = [String: Date]
//   typealias InAppPurchaseList = [[String: Any]]
//   typealias ProductDateDict = [String: [ProductDateHelper]]
}
/// Check if a subscription should be considered active for a given expiry date.
//private func isSubscriptionActive(forExpiryDate expiryDate: Date) -> Bool {
//   let leewayTimeInterval = self..subscriptionRenewalLeeway.allowedElapsedDuration
//
//   return expiryDate.addingTimeInterval(leewayTimeInterval) > self.nowDate
//}
