import Foundation
/// An InAppReceipt extension helps to initialize the receipt
public extension InAppReceipt {
   /// Creates and returns the 'InAppReceipt' instance from data object
   ///
   /// - Returns: 'InAppReceipt' instance
   /// - throws: An error in the InAppReceipt domain, if `InAppReceipt` cannot be created.
   static func receipt(from data: Data) throws -> InAppReceipt {
      try InAppReceipt(receiptData: data)
   }
   /// Creates and returns the 'InAppReceipt' instance using local receipt
   ///
   /// - Returns: 'InAppReceipt' instance
   /// - throws: An error in the InAppReceipt domain, if `InAppReceipt` cannot be created.
   static func localReceipt() throws -> InAppReceipt {
      let data: Data = try Bundle.main.appStoreReceiptData()
      return try InAppReceipt.receipt(from: data)
   }
}
/// A Bundle extension helps to retrieve receipt data
public extension Bundle {
   /// Retrieve local App Store Receip Data
   ///
   /// - Returns: 'Data' object that represents local receipt
   /// - throws: An error if receipt file not found or 'Data' can't be created
   func appStoreReceiptData() throws -> Data {
      guard let receiptUrl: URL = appStoreReceiptURL,
            FileManager.default.fileExists(atPath: receiptUrl.path) else {
         throw IARError.initializationFailed(reason: .appStoreReceiptNotFound)
      }

      do {
         return try Data(contentsOf: receiptUrl)
      } catch {
         throw IARError.initializationFailed(reason: .appStoreReceiptNotFound)
      }
   }
   /// Retrieve local App Store Receip Data in base64 string
   ///
   /// - Returns: 'Data' object that represents local receipt
   /// - throws: An error if receipt file not found or 'Data' can't be created
   func appStoreReceiptBase64() throws -> String {
      try appStoreReceiptData().base64EncodedString()
   }
   class func lookUp(forResource name: String, ofType ext: String?) -> String? {
      if let p: String = Bundle.module.path(forResource: name, ofType: ext) {
         return p
      }
      if let p: String = Bundle.main.path(forResource: name, ofType: ext) {
         return p
      }
      for f: Bundle in Bundle.allFrameworks {
         if let identifier: String = f.bundleIdentifier, identifier.contains("TPInAppReceipt"),
            let p: String = f.path(forResource: name, ofType: ext) {
            return p
         }
      }
      return nil
   }
}
