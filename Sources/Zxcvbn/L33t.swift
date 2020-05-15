import Foundation

struct L33t {
    static func substitutions(_ string: String) -> [[String: String]] {
        func dedupe(_ substitutions: [[[String]]]) -> [[[String]]] {
            var deduped: [[[String]]] = []
            var members: [String] = []
            for substitution in substitutions {
                let sorted = substitution.sorted { $0[0] > $1[0]}
                let label: String = sorted.map { $0.joined(separator: ",") }.joined(separator: "-")
                if !members.contains(label) {
                    members.append(label)
                    deduped.append(substitution)
                }
            }
            return deduped
        }
        
        let table: [String: [String]] = substitutionTable(string)
        var substitutions: [[[String]]] = [[]]
        var keys: [String] = table.keys.map { key in
            return "\(key)"
        }
        while keys.count > 0 {
            let key: String = keys[0] as String
            keys.remove(at: 0)
            var nextSubstitutions: [[[String]]] = []
            for l33tCharacter in table[key]! {
                for substitution in substitutions {
                    var l33tIndex: Int = -1
                    for index in 0..<substitution.count {
                        guard substitution[index].first == l33tCharacter else {
                            continue
                        }
                        l33tIndex = index
                        break
                    }
                    var substitutionExtension: [[String]] = substitution
                    if l33tIndex != -1 {
                        nextSubstitutions.append(substitution)
                        substitutionExtension.remove(at: l33tIndex)
                    }
                    substitutionExtension.append([l33tCharacter, key])
                    nextSubstitutions.append(substitutionExtension)
                }
            }
            substitutions = dedupe(nextSubstitutions)
        }
        var dictionaries: [[String: String]] = []
        for substitution in substitutions {
            var dictionary: [String: String] = [:]
            for pair in substitution {
                guard pair.count == 2 else {
                    continue
                }
                dictionary[pair[0]] = pair[1]
            }
            dictionaries.append(dictionary)
        }
        return dictionaries
    }
    
    static func substitutionTable(_ string: String) -> [String: [String]] {
        var table: [String: [String]] = substitutionTable
        for key in table.keys {
            table[key] = table[key]!.filter { value in
                return string.contains(value)
            }
            if table[key]!.isEmpty {
                table.removeValue(forKey: key)
            }
        }
        return table
    }
    
    static var substitutionTable: [String: [String]] {
        return try! JSONDecoder().decode([String: [String]].self, from: L33t_Data)
    }
    
    let dictionaries: [Dictionary]
    
    init(dictionaries: [Dictionary] = Dictionary.allCases) {
        self.dictionaries = dictionaries
    }
}

extension L33t: Matching {
    
    // MARK: Matching
    func matches(_ string: String) -> [Match] {
        func translate(_ string: String, with dictionary: [String: String]) -> String {
            var string: String = string
            for key in dictionary.keys {
                string = string.replacingOccurrences(of: "\(key)", with: dictionary[key]!)
            }
            return string
        }
        var matches: [L33tMatch] = []
        for substitution in Self.substitutions(string) {
            guard !substitution.isEmpty else {
                continue
            }
            for match in dictionaries.matches(translate(string, with: substitution)) {
                let token: String = string.map { "\($0)" }[match.range].joined()
                guard let match: DictionaryMatch = match as? DictionaryMatch,
                    match.matched != token.lowercased() else {
                    continue
                }
                matches.append(L33tMatch(dictionary: match, token: token, substitutions: substitution.filter { token.contains($0.key) }))
            }
        }
        return matches
    }
}

struct L33tMatch: Match {
    let dictionaryMatch: DictionaryMatch
    let substitutions: [String: String]
    
    init(dictionary match: DictionaryMatch, token: String, substitutions: [String: String]) {
        dictionaryMatch = match
        range = match.range
        self.substitutions = substitutions
        self.token = token
    }
    
    // MARK: Match
    let range: ClosedRange<Int>
    let token: String
    let pattern: String = "l33t"
    
    var entropy: Double {
        var possibilities: Double = 0.0
        for key in substitutions.keys {
            let keyLength: Int = token.components(separatedBy: key).count - 1
            let valueLength: Int = token.components(separatedBy: substitutions[key]!).count - 1
            for i in 0...min(keyLength, valueLength) {
                possibilities += Double(binomial: keyLength + valueLength, i)
            }
        }
        return dictionaryMatch.entropy + max(log2(possibilities), 1.0)
    }
}

private let L33t_Data: Data = """
{
    "a": [
        "4",
        "@"
    ],
    "b": [
        "8"
    ],
    "c": [
        "(",
        "{",
        "[",
        "<"
    ],
    "e": [
        "3"
    ],
    "g": [
        "6",
        "9"
    ],
    "i": [
        "1",
        "!",
        "|"
    ],
    "l": [
        "1",
        "|",
        "7"
    ],
    "o": [
        "0"
    ],
    "s": [
        "$",
        "5"
    ],
    "t": [
        "+",
        "7"
    ],
    "x": [
        "%"
    ],
    "z": [
        "2"
    ]
}
""".data(using: .utf8)!
