import Foundation
import Zxcvbn

extension Zxcvbn.Dictionary: CustomStringConvertible {
    
    // MARK: CustomStringConvertible
    public var description: String {
        return rawValue
    }
}
