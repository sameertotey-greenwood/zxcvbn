import Foundation

enum Dictionary: RawRepresentable, Equatable, CaseIterable {
    case passwords, english, femaleNames, surnames, maleNames, custom([String])
    
    var ranked: [String: Int] {
        func ranked(strings: [String]) -> [String: Int] {
            var ranked: [String: Int] = [:]
            for (index, string) in strings.enumerated() {
                ranked[string] = index + 1
            }
            return ranked
        }
        
        switch self {
        case .custom(let strings):
            return ranked(strings: strings)
        default:
            if Self.ranked == nil {
                let url: URL = Bundle.module.url(forResource: "Dictionary", withExtension: "json")!
                let dictionary: [String: [String]] = try! JSONDecoder().decode([String: [String]].self, from: try! Data(contentsOf: url))
                Self.ranked = [:]
                for key in dictionary.keys {
                    Self.ranked?[key] = ranked(strings: dictionary[key]!)
                }
            }
            return Self.ranked![rawValue]!
        }
    }
    
    private static var ranked: [String: [String: Int]]?
    
    // MARK: RawRepresentable
    var rawValue: String {
        switch self {
        case .passwords:
            return "passwords"
        case .english:
            return "english"
        case .femaleNames:
            return "female_names"
        case .surnames:
            return "surnames"
        case .maleNames:
            return "male_names"
        case .custom:
            return "custom"
        }
    }
    
    init?(rawValue: String) {
        fatalError("init(rawValue:) has not been implemented")
    }
    
    // MARK: CaseIterable
    static let allCases: [Self] = [.passwords, .english, .femaleNames, .surnames, .maleNames]
}

extension Dictionary: Matching {
    
    // MARK: Matching
    func matches(_ string: String) -> [Match] {
        let ranked: [String: Int] = self.ranked
        let components: [String] = string.components
        let lowercasedComponents: [String] = string.lowercased().components
        var matches: [DictionaryMatch] = []
        for i in 0..<string.count {
            for j in i..<string.count {
                let range: ClosedRange<Int> = i...j
                let matched: String = lowercasedComponents[range].joined()
                guard let rank: Int = ranked[matched] else {
                    continue
                }
                matches.append(DictionaryMatch(rank: rank, matched: matched, dictionaryName: rawValue, range: range, token: components[range].joined()))
            }
        }
        return matches
    }
}

public struct DictionaryMatch: Match {
    public let rank: Int
    public let matched: String
    public let dictionaryName: String
    
    // MARK: Match
    public static let pattern: String = "dictionary"
    public let range: ClosedRange<Int>
    public let token: String
    
    public var entropy: Double {
        return log2(Double(rank)) + uppercasedEntropy
    }
    
    private var uppercasedEntropy: Double {
        let components: [String] = token.components
        let uppercased: [Int] = components.enumerated().compactMap { index, component in
            return "ABCDEFGHIJKLMNOPQRSTUVWXYZ".contains(component) ? index : nil
        }
        let lowercased: [Int] = components.enumerated().compactMap { index, component in
            return "abcdefghijklmnopqrstuvwxyz".contains(component) ? index : nil
        }
        guard !uppercased.isEmpty else {
            return 0.0
        }
        guard matched.uppercased() != matched,
            !(uppercased.contains(0) && !uppercased.contains(1)),
            !(uppercased.contains(components.count - 1) && !uppercased.contains(components.count - 2)) else {
            return 1.0
        }
        var possibilities: Double = 0.0
        for i in 0...min(uppercased.count, lowercased.count) {
            possibilities += Double(binomial: uppercased.count + lowercased.count, i)
        }
        return log2(possibilities)
    }
}
