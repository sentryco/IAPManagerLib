import Foundation
/**
 * - Fixme: ⚠️️ refactor
 */
public struct ProductDateHelper {
   /**
    * The date that the product was purchased.
    */
   public var purchaseDate: Date = .init(timeIntervalSince1970: 0)
   /**
    * The date that the product expires.
    */
   public var expiresDate: Date?
   /**
    * The date that the product was canceled.
    */
   public var canceledDate: Date?
   /**
    * Returns the valid date for a purchase with the given parameters.
    * - Parameters:
    *   - lastCanceledDate: The date the last purchase was canceled.
    *   - unlimitedDate: The unlimited date.
    * - Returns: The valid date for the purchase.
    * - Remark: If the last canceled date is not nil, the method checks if the purchase date is after the last canceled date. If it is, the method returns the expiration date if it exists, otherwise it returns the unlimited date. If the purchase date is not after the last canceled date, the method returns the last canceled date. If the canceled date is not nil, the method returns the canceled date. If the expiration date is not nil, the method returns the expiration date. If there is no canceled date or expiration date, the method returns the unlimited date.
    */
   public func getValidDate(lastCanceledDate: Date?, unlimitedDate: Date) -> Date {
      if let lastCanceledDate: Date = lastCanceledDate { // Check if the last canceled date is not nil
         return (purchaseDate.timeIntervalSince1970 > lastCanceledDate.timeIntervalSince1970) // Check if the purchase date is after the last canceled date
         ? (expiresDate ?? unlimitedDate) // Return the expiration date if it exists, otherwise return the unlimited date
         : lastCanceledDate // Return the last canceled date if the purchase date is not after the last canceled date
      }
      if let canceledDate: Date = canceledDate { // Check if the canceled date is not nil
         return canceledDate // Return the canceled date
      } else if let expiresDate: Date = expiresDate { // Check if the expiration date is not nil
         return expiresDate // Return the expiration date
      } else { // Otherwise
         return unlimitedDate // Return the unlimited date
      }
   }
}
