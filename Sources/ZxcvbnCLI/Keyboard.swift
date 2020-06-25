import Foundation
import Zxcvbn

extension Keyboard: CustomStringConvertible {
    
    // MARK: CustomStringConvertible
    public var description: String {
        return rawValue
    }
}
