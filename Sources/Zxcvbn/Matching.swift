import Foundation

protocol Matching {
    func matches(_ string: String) -> [Match]
}

protocol Match {
    var range: ClosedRange<Int> {
        get
    }
    
    var token: String {
        get
    }
    
    var pattern: String {
        get
    }
}
