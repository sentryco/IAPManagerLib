import Foundation
/**
 * DEPRECATED ⚠️️
 * One time purchase like lifetime subscription etc, Buy once use forever
 */
struct IAPNonConsumable: Codable, ProductKind {
   var id: String
   // - Fixme: ⚠️️ rather call AppStore.isValid(prodID)? which calls local validator as we dont need to check if duration is continued etc
   var isValid: Bool
}
