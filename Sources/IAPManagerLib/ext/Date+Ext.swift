import Foundation

extension Date {
   /**
    * Initialize a new instance of Date with the given milliseconds since 1970
    */
   internal init(millisecondsSince1970 milliseconds: Int) {
      self.init(timeIntervalSince1970: Double(milliseconds / 1000))
   }
}
