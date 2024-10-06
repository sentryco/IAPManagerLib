import Foundation
// - Fixme: ⚠️️ not sure what this does
extension Result where Success == Void {
   internal static var success: Result<Void, Failure> {
      .success(())
   }
}
