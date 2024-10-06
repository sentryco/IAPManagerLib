import Foundation
/**
 * - Description: Convenient place to store values related to IAP implementation
 * - Remark: In the sample app, you’ll use hard-coded Product Identifiers. In real life, you’d prefer the flexibility of fetching these from a server.
 * - Fixme: ⚠️️ Maybe use a github json file as remote config file? or just be agressive with app update and limiting old versions of the app etc?
 * ## Example:
 * let config = IAPConfig(appName: "MyApp", appID: "co.company.MyApp", termsOfServiceLink: "gist.github.com/user/tos.txt", privacyAgreementLink: "gist.github.com/user/pa.txt")
 */
public struct IAPConfig {
   public let appName: String // Name of app
   public let appID: String // App id
   public let termsOfServiceLink: String // Link to gist file on github?
   public let privacyAgreementLink: String // Link to gist file on github?
   /**
    * Initializes an `IAPConfig` object with the given parameters.
    *
    * - Parameters:
    *   - appName: The name of the app.
    *   - appID: The ID of the app.
    *   - termsOfServiceLink: The link to the app's terms of service.
    *   - privacyAgreementLink: The link to the app's privacy agreement.
    */
   public init(appName: String, appID: String, termsOfServiceLink: String, privacyAgreementLink: String) {
      self.appName = appName
      self.appID = appID
      self.termsOfServiceLink = termsOfServiceLink
      self.privacyAgreementLink = privacyAgreementLink
   }
}
