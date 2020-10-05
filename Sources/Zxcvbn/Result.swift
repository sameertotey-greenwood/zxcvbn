import Foundation

public struct Result {
    public enum Score: Int, CaseIterable, Comparable, Identifiable {
        case none = 0
        case insufficient = 1
        case weak = 2
        case sufficient = 3
        case strong = 4
        
        init(_ crackTime: TimeInterval) {
            if crackTime < pow(10.0, 2.0) {
                self = .none
            } else if crackTime < pow(10.0, 4.0) {
                self = .insufficient
            } else if crackTime < pow(10.0, 6.0) {
                self = .weak
            } else if crackTime < pow(10.0, 8.0) {
                self = .sufficient
            } else {
                self = .strong
            }
        }
        
        // MARK: Comparable
        public static func < (lhs: Self, rhs: Self) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
        
        // MARK: Identifiable
        public var id: Int {
            return rawValue
        }
    }
    
    public let string: String
    public let matches: [Match]
    public let entropy: Double
    public let calculationTime: TimeInterval
    public let crackTime: TimeInterval
    public let score: Score
    
    init(string: String, matching: [Matching] = []) {
        let date: Date = Date()
        let components: [String] = string.components
        var matches: [Match] = []
        for pattern in matching {
            matches.append(contentsOf: pattern.matches(string))
        }
        var upToK: [Double] = []
        var backPointers: [Match?] = []
        for k in 0..<components.count {
            upToK.append((k > 0 ? upToK[k - 1] : 0.0) + log2(Double(string.cardinality)))
            backPointers.append(nil)
            for match in matches {
                guard match.range.upperBound == k else {
                    continue
                }
                let entropy: Double = (match.range.lowerBound > 0 ? upToK[match.range.lowerBound - 1] : 0.0) + match.entropy
                if entropy < upToK[k] {
                    upToK[k] = entropy
                    backPointers[k] = match
                }
            }
        }
        var matchSequence: [Match] = []
        var k: Int = components.count - 1
        while k >= 0 {
            if let match: Match = backPointers[k] {
                matchSequence.append(match)
                k = match.range.lowerBound - 1
            } else {
                k -= 1
            }
        }
        matchSequence.reverse()
        k = 0
        matches = []
        for match in matchSequence {
            if match.range.lowerBound - k > 0,
                let match: BruteForceMatch = BruteForceMatch(range: k...(match.range.lowerBound - 1), string: string) {
                matches.append(match)
            }
            matches.append(match)
            k = match.range.upperBound + 1
        }
        if k < string.count,
            let match: BruteForceMatch = BruteForceMatch(range: k...(string.count - 1), string: string) {
            matches.append(match)
        }
        self.string = string
        self.matches = matches
        entropy = upToK.last ?? 0.0
        self.crackTime = 0.5 * pow(2.0, entropy) * 0.0001
        score = Score(self.crackTime)
        calculationTime = abs(date.timeIntervalSinceNow)
    }
}
