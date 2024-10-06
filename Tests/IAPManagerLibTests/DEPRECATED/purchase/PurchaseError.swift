import Foundation
// DEPRECATED ⚠️️
enum PurchaseError: Error {
   case unknown
   case clientInvalid
   case paymentCancelled
   case paymentInvalid
   case paymentNotAllowed
   case storeProductNotAvailable
   case cloudServicePermissionDenied
   case cloudServiceNetworkConnectionFailed
   case cloudServiceRevoked
}
extension PurchaseError {
   var description: String {
      switch self {
      case .unknown:
         return "Purchase failed \(self.localizedDescription)" // (error as NSError).localizedDescription
      case .clientInvalid:  // client is not allowed to issue the request, etc.
         return "Purchase failed \("Not allowed to make the payment")"
      case .paymentCancelled: // user cancelled the request, etc.
         return ""
      case .paymentInvalid: // purchase identifier was invalid, etc.
         return "Purchase failed \("The purchase identifier was invalid")"
      case .paymentNotAllowed:// this device is not allowed to make the payment
         return "Purchase failed \("The device is not allowed to make the payment")"
      case .storeProductNotAvailable: // Product is not available in the current storefront
         return "Purchase failed \("The product is not available in the current storefront")"
      case .cloudServicePermissionDenied: // user has not allowed access to cloud service information
         return "Purchase failed \("Access to cloud service information is not allowed")"
      case .cloudServiceNetworkConnectionFailed: // the device could not connect to the nework
         return "Purchase failed \("Could not connect to the network")"
      case .cloudServiceRevoked: // user has revoked permission to use this cloud service
         return "Purchase failed \("Cloud service was revoked")"
      }
   }
}
