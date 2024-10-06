import Foundation
/// Error when managing receipt
public enum ReceiptError: Swift.Error {
   case noReceiptData /// No receipt data
   case noRemoteData /// No data received
   case requestBodyEncodeError(error: Swift.Error) /// Error when encoding HTTP body into JSON
   case networkError(error: Swift.Error) /// Error when proceeding request
   case jsonDecodeError(string: String?) /// Error when decoding response
//   case receiptInvalid(receipt: ReceiptInfo, status: ReceiptStatus)  /// Receive invalid - bad status returned
}
