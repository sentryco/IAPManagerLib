import Foundation
/**
 * DEPRECATED ⚠️️
 * Renews every period for x price
 * - Remark: this can be year, day month etc
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
   // - Fixme: ⚠️️ rather call AppStore.isValid(prodID)? which calls remote validator
   var isValid: Bool {
      Date.now <= expirationDate
   }
}
