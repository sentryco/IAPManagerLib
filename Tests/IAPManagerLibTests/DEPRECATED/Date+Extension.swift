import Foundation


public extension Date {
   func rfc3339date(fromString string: String) -> Date? {
      string.rfc3339date()
   }
}

public extension String {
   func rfc3339date() -> Date? {
      let date: Date? = rfc3339DateFormatter.date(from: self)
      return date
   }
}

fileprivate var rfc3339DateFormatter: ISO8601DateFormatter = {
   let formatter: ISO8601DateFormatter = .init()
   formatter.formatOptions = .withInternetDateTime
   formatter.timeZone = TimeZone(abbreviation: "UTC")
   return formatter
}()
