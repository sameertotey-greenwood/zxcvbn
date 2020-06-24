import Foundation

struct BruteForceMatch: Match {
    
    init?(range: ClosedRange<Int>, string: String) {
        guard !string.isEmpty, range.lowerBound >= 0, range.upperBound < string.count else {
            return nil
        }
        self.range = range
        token = string.components[range].joined()
        entropy = log2(pow(Double(string.cardinality), Double((range.upperBound - range.lowerBound) + 1)))
    }
    
    // MARK: Match
    static let pattern: String = "bruteforce"
    let range: ClosedRange<Int>
    let token: String
    let entropy: Double
}
