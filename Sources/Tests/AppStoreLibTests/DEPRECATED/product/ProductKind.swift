import Foundation
import JSONSugar
/**
 * This is the way we store receipts locally
 * - Fixme: ⚠️️ However, we should rather validate online, even if more unsafe, and make the offline validator for the lifetime sub with kvitto etc
 * - Fixme: ⚠️️ Use the json that supports decoding to type. see `CredentialKind etc
 */
protocol ProductKind: Codable {
   var id: String { get }
   var isValid: Bool { get }
}
// Add:
// case autoRenewableWeekly
// case autoRenewableMonthly
// case autoRenewableYearly
// case nonRenewingPurchase
enum ProductType: Codable {
   /// Type that are depleted after one use. Customers can purchase them multiple times.
   // consumablePurchase
   // - Note: Alt name: autoRenewableMonthly
   case monthlySub(IAPMonthlySubProduct)  
   /// Type that customers purchase once. They don't expire.
   /// - Note: Alt name: nonConsumablePurchase
   case nonConsumable(IAPNonConsumable)
}
/**
 * - Description: Enables the json setup to make protocol + multiple struct decode to json and encode back to correct type
 */
extension ProductType: RawRepresentable {
   public typealias RawValue = ProductKind
   enum CodingKeys: String, CodingKey {
      case monthlySub, nonConsumable
   }
   public func encode(to encoder: Encoder) throws {
      var container: KeyedEncodingContainer<ProductType.CodingKeys> = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(self.rawValue as? IAPMonthlySubProduct, forKey: .monthlySub)
      try container.encode(self.rawValue as? IAPNonConsumable, forKey: .nonConsumable)
   }
   public init(from decoder: Decoder) throws {
      let container: KeyedDecodingContainer<ProductType.CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
      if let monthlySub = try? container.decode(IAPMonthlySubProduct.self, forKey: .monthlySub) { self = .monthlySub(monthlySub); return }
      if let nonConsumable = try? container.decode(IAPNonConsumable.self, forKey: .nonConsumable) { self = .nonConsumable(nonConsumable); return }
      throw DecodingError.typeMismatch(ProductType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "⚠️️ Wrong type for ConfigDatumElement")) // [_JSONKey(stringValue: "Index 3", intValue: 3)], debugDescription: "Wrong type for ConfigDatumElement", underlyingError: nil))
   }
   /**
    * This can never throw, won't adher to rawrepresentable then
    */
   public init?(rawValue: RawValue) {
      switch rawValue {
      case let monthlySub as IAPMonthlySubProduct: self = .monthlySub(monthlySub)
      case let nonConsumable as IAPNonConsumable: self = .nonConsumable(nonConsumable)
      default: return nil
      }
   }
   /**
    * We do it this way in order to be able to extract type from json etc (Support for hetrogeneouse JSON)
    */
   public var rawValue: RawValue {
      switch self {
      case .monthlySub(let monthlySub): return monthlySub
      case .nonConsumable(let nonConsumable): return nonConsumable
      }
   }
   static func decode(data: Data?) throws -> ProductKind {
      guard let data: Data = data else { throw NSError(domain: "data is nil", code: 0) }
      let productType: ProductType = try data.decode()
      return productType.rawValue
   }
   static func data(rawValue: RawValue) throws -> Data {
      guard let type: ProductType = .init(rawValue: rawValue) else { throw NSError(domain: "err type", code: 0) }
      return try type.encode()
   }
}
