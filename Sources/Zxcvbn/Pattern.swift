import Foundation

enum Pattern: String, CaseIterable {
    case digits, year, date
    
    var expression: NSRegularExpression {
        switch self {
        case .date:
            return try! NSRegularExpression(pattern: "(\\d{1,2})( |-|\\/|\\.|_)?(\\d{1,2})( |-|\\/|\\.|_)?(19\\d{2}|200\\d|201\\d|\\d{2})", options: [])
        case .year:
            return try! NSRegularExpression(pattern: "19\\d\\d|200\\d|201\\d", options: [])
        case .digits:
            return try! NSRegularExpression(pattern: "\\d{3,}", options: [])
        }
    }
}

extension Pattern: Matching {
    
    // MARK: Matching
    func matches(_ string: String) -> [Match] {
        var matches: [PatternMatch] = []
        for result in expression.matches(in: string, options: [], range: NSRange(location: 0, length: string.count)) {
            let range: ClosedRange<Int> = result.range.lowerBound...(result.range.upperBound - 1)
            let token: String = string.components[range].joined()
            var components: [Int] = []
            if self == .date, result.numberOfRanges == 6 {
                components = [result.range(at: 5), result.range(at: 1), result.range(at: 3)].compactMap { range in
                    guard range.location < string.components.count else {
                        return nil
                    }
                    return Int(string.components[range.location...(range.location + range.length - 1)].joined())
                }
                guard components.count == 3 else {
                    continue
                }
                if components[1] >= 12, components[1] <= 31, components[2] <= 12 {
                    components = [components[0], components[2], components[1]]
                }
                guard components[1] < 13, components[2] < 32 else {
                    continue
                }
                if components[0] < 20 {
                    components[0] += 2000
                } else if components[0] < 100 {
                    components[0] += 1900
                }
                if result.range(at: 2).location < string.components.count {
                    components.append(0)
                }
            } else if let component: Int = Int(token) {
                components = [component]
            }
            matches.append(PatternMatch(self, range: range, token: token, components: components))
        }
        return matches
    }
}

struct PatternMatch: Match {
    let expression: NSRegularExpression
    let components: [Int]
    
    init(_ pattern: Pattern, range: ClosedRange<Int>, token: String, components: [Int] = []) {
        self.expression = pattern.expression
        self.components = components
        self.range = range
        self.token = token
        self.pattern = pattern.rawValue
    }
    
    // MARK: Match
    let range: ClosedRange<Int>
    let token: String
    let pattern: String
    
    var entropy: Double {
        switch Pattern(rawValue: pattern)! {
        case .date:
            return log2((components.first ?? 0 < 100 ? 100.0 : 119.0) * 12.0 * 31.0) + (components.count == 4 ? 2.0 : 0.0)
        case .year:
            return log2(119.0)
        case .digits:
            return log2(pow(10.0, Double(token.count)))
        }
    }
}
