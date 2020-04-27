import Foundation

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

protocol Matching {
    func matches(_ string: String) -> [Match]
}

extension Array: Matching where Element == Matching {
    
    // MARK: Matching
    func matches(_ string: String) -> [Match] {
        var matches: [Match] = []
        for element in self {
            matches.append(contentsOf: element.matches(string))
        }
        return matches
    }
}
