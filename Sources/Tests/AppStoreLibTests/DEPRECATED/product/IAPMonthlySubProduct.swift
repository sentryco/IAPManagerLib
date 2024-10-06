import Foundation
/**
 * Renews every month for x price
 * - Note: Alt name: `AutoRenewableConsumable`
 */
struct IAPMonthlySubProduct: Codable, ProductKind {
   var id: String
   var startDate: Date
   var durationInMonths: Int
}
/**
 * Ext
 */
extension IAPMonthlySubProduct {
   var expirationDate: Date {
      Calendar.current.date(byAdding: .month, value: 1, to: startDate)!
   }
   /**
    * - Fixme: ⚠️️ rather call AppStore.isValid(prodID)? which calls remote validator
    */
   var isValid: Bool {
      Date.now <= expirationDate
   }
}
