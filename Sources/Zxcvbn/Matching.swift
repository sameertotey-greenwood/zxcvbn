import Foundation

protocol Matching {
    func matches(_ string: String) -> [Match]
}

public protocol Match {
    static var pattern: String {
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

extension Match {
    public var pattern: String {
        return Self.pattern
    }
}
