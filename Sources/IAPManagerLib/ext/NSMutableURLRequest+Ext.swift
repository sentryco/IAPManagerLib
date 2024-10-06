import Foundation

extension NSMutableURLRequest {
   /**
    * A convenient initializer for creating an `NSMutableURLRequest` with a URL, HTTP method, and HTTP body.
    *
    * - Parameters:
    *   - url: The URL for the request.
    *   - httpMethod: The HTTP method for the request.
    *   - httpBody: The HTTP body for the request.
    */
   convenience init(url: URL, httpMethod: String, httpBody: Data) {
      self.init(url: url)
      self.httpMethod = httpMethod
      self.httpBody = httpBody
   }
}
