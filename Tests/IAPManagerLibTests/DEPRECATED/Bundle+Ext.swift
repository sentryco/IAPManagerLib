import Foundation

extension Bundle {
   /// Appropriate app version for receipt validation
   var appVersion: String? {
      #if targetEnvironment(macCatalyst) || os(macOS)
      let dictKey: String = "CFBundleShortVersionString"
      #else
      let dictKey: String = "CFBundleVersion"
      #endif
      guard let v: String = infoDictionary?[dictKey] as? String else {
         return nil
      }
      return v
   }
}

import class Foundation.Bundle
extension Foundation.Bundle {
   static var module: Bundle =
   {
      Bundle(for: _TPInAppReceipt.self)
   }()
}

fileprivate class _TPInAppReceipt {}
