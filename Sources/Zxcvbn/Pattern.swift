import Foundation

struct Pattern: CustomStringConvertible, CaseIterable {
    static var date: Pattern {
        return try! Self(expression: "(\\d{1,2})( |-|\\/|\\.|_)?(\\d{1,2})( |-|\\/|\\.|_)?(19\\d{2}|200\\d|201\\d|\\d{2})", description: "date")
    }
    
    static var year: Pattern {
        return try! Self(expression: "19\\d\\d|200\\d|201\\d", description: "year")
    }
    
    static var digits: Pattern {
        return try! Self(expression: "\\d{3,}", description: "digits")
    }
    
    let expression: NSRegularExpression
    
    private init(expression pattern: String, description: String = "pattern") throws {
        self.expression = try NSRegularExpression(pattern: pattern, options: [])
        self.description = description
    }
    
    // MARK: CustomStringConvertible
    let description: String
    
    // MARK: CaseIterable
    static let allCases: [Self] = [.date, .year, .digits]
}

extension Pattern: Matching {
    
    // MARK: Matching
    func matches(_ string: String) -> [Match] {
        let components: [String] = string.map { character in
            return "\(character)"
        }
        var matches: [PatternMatch] = []
        for result in expression.matches(in: string, options: [], range: NSRange(location: 0, length: string.count)) {
            let range: ClosedRange<Int> = result.range.lowerBound...(result.range.upperBound - 1)
            matches.append(PatternMatch(expression: expression, range: range, token: components[range].joined(), description: description))
        }
        return matches
    }
}

struct PatternMatch: Match, CustomStringConvertible {
    let expression: NSRegularExpression
    
    // MARK: Match
    let range: ClosedRange<Int>
    let token: String
    let pattern: String = "pattern"
    
    // MARK: CustomStringConvertible
    let description: String
}
