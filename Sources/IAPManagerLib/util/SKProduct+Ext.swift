import Foundation // Import the Foundation framework
import StoreKit // Import the StoreKit framework
import Logger // Import the Logger framework
/**
 * An extension to `SKProduct` that provides additional functionality.
 * - Fixme: ⚠️️ we can maybe use NSArchiver for SKProduct since it's NSObject etc
 * - Note: There is also something called: https://github.com/bizz84/SwiftyStoreKit/blob/master/Sources/SwiftyStoreKit/SKProductDiscount%2BLocalizedPrice.swift
 */
extension SKProduct {
   /**
    * Returns localized price
    * - Remark: The devs chooses the appropriate price tier in iTunes Connect and the store takes care of showing prices to the user. In the example where there is an unsupported currency, Apple also makes that decision for the dev as well.
    * - Remark: Also note devs are discouraged from displaying prices on their own, which Apple fears could lead to mistake and confusion if they make changes later
    */
   var localizedPrice: String? {
      Self.getLocalizedPrice(price: price, locale: priceLocale) // Get the localized price for the given price and locale
   }
   /**
      * Returns the localized price for the given price and locale
      * - Remark: Only the prefix of the price is localized, the currency price itself is not converted.
      * - Parameters:
      *   - price: The price from StoreKit
      *   - locale: The locale to use for localization
      */
   public static func getLocalizedPrice(price: NSDecimalNumber, locale: Locale) -> String? {
      priceFormatter(locale: locale).string(from: price) // Format the price using the price formatter for the given locale
   }
   /**
   * Returns a number formatter for SKProduct prices
   * - Remark: More formatters can be found at https://github.com/benjaminmayo/merchantkit/blob/master/Source/User%20Interface/PriceFormatter.swift
   * - Remark: The formatter uses the given locale, or the current locale if none is provided. The formatter is set to currency style.
   * - Parameter locale: The locale to use for the formatter
   * - Returns: A number formatter for SKProduct prices
   */
   private static func priceFormatter(locale: Locale = .current) -> NumberFormatter {
      let formatter: NumberFormatter = .init() // Initialize a number formatter
      formatter.locale = locale // Set the locale for the formatter
      formatter.numberStyle = .currency // Set the number style for the formatter to currency
      return formatter // Return the formatter
   }
   /**
   * Returns a localized string for the subscription period of the product
   * - Remark: The localized string is in a short format, such as "1 mo" for one month
   * - Returns: A localized string for the subscription period of the product, or an empty string if the subscription period is nil
   */
   @available(iOSApplicationExtension 11.2, iOS 11.2, OSX 10.13.2, tvOS 11.2, watchOS 6.2, macCatalyst 13.0, *)
   var localizedSubscriptionPeriod: String {
      guard let subscriptionPeriod: SKProductSubscriptionPeriod = self.subscriptionPeriod else { return "" } // Check if there is a subscription period, return an empty string if there isn't
      let dateComponents: DateComponents // Initialize a date components object
      switch subscriptionPeriod.unit { // Switch on the subscription period unit
      case .day: dateComponents = DateComponents(day: subscriptionPeriod.numberOfUnits) // Set the date components to the number of days
      case .week: dateComponents = DateComponents(weekOfMonth: subscriptionPeriod.numberOfUnits) // Set the date components to the number of weeks
      case .month: dateComponents = DateComponents(month: subscriptionPeriod.numberOfUnits) // Set the date components to the number of months
      case .year: dateComponents = DateComponents(year: subscriptionPeriod.numberOfUnits) // Set the date components to the number of years
      @unknown default:
         Logger.warn("\(Trace.trace()) - WARNING: this libs localizedSubscriptionPeriod does not handle all SKProduct.PeriodUnit cases.") // Log a warning message if there is an unknown subscription period unit
         // Default to month units in the unlikely event a different unit type is added to a future OS version
         dateComponents = DateComponents(month: subscriptionPeriod.numberOfUnits) // Set the date components to the number of months
      }
      return DateComponentsFormatter.localizedString(from: dateComponents, unitsStyle: .short) ?? "" // Return the localized string from the date components with the short units style, or an empty string if the localized string is nil
   }
}
