import Foundation

protocol Matching {
    func matches(_ string: String) -> [Match]
}

public protocol Match {
    var pattern: String {
        get
    }
    
    var range: ClosedRange<Int> {
        get
    }
    
    var token: String {
        get
    }
    
    var entropy: Double {
        get
    }
}
