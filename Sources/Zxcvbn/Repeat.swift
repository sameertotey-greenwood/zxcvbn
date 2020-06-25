import Foundation

struct Repeat {
    
}

extension Repeat: Matching {
    
    // MARK: Matching
    func matches(_ string: String) -> [Match] {
        let components: [String] = string.components
        var matches: [RepeatMatch] = []
        var i: Int = 0
        while i < components.count {
            var j: Int = i + 1
            while true {
                let previousComponent: String = components[j - 1]
                let currentComponent: String = j < components.count ? components[j] : ""
                if previousComponent == currentComponent {
                    j += 1
                } else {
                    if j - i > 2 {
                        let range: ClosedRange<Int> = i...(j - 1)
                        matches.append(RepeatMatch(repeated: components[i], range: range, token: components[range].joined()))
                    }
                    break
                }
            }
            i = j
        }
        return matches
    }
}

public struct RepeatMatch: Match {
    public let repeated: String
    
    // MARK: Match
    public let pattern: String = "repeat"
    public let range: ClosedRange<Int>
    public let token: String
    
    public var entropy: Double {
        return log2(Double(token.cardinality * token.count))
    }
}
