import Foundation

public enum ReceiptStatus: Int {
   case noRecipt = -999 // The receipt is missing
   case valid = 0 // The receipt is valid
   case testReceipt = 21_007 // The receipt is a test receipt
}
