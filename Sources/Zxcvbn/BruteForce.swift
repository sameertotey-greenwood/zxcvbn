import Foundation

public struct BruteForceMatch: Match {
    init?(range: ClosedRange<Int>, string: String) {
        guard !string.isEmpty, range.lowerBound >= 0, range.upperBound < string.count else {
            return nil
        }
        self.range = range
        token = string.components[range].joined()
        entropy = log2(pow(Double(string.cardinality), Double((range.upperBound - range.lowerBound) + 1)))
    }
    
    // MARK: Match
    public let pattern: String = "bruteforce"
    public let range: ClosedRange<Int>
    public let token: String
    public let entropy: Double
}
