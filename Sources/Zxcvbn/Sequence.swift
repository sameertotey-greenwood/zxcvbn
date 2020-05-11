import Foundation

enum Sequence: String, CaseIterable {
    case lowercasedAlphabet = "abcdefghijklmnopqrstuvwxyz"
    case uppercasedAlphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    case numerals = "01234567890"
}

extension Sequence: Matching {
    
    // MARK: Matching
    func matches(_ string: String) -> [Match] {
        let rawComponents: [String] = rawValue.map { character in
            return "\(character)"
        }
        let components: [String] = string.map { character in
            return "\(character)"
        }
        var matches: [SequenceMatch] = []
        var i: Int = 0
        while i < components.count {
            var j: Int = i + 1
            let ii: Int? = rawComponents.firstIndex(of: components[i])
            let jj: Int? = j < components.count ? rawComponents.firstIndex(of: components[j]) : nil
            guard ii != nil, jj != nil,
                let direction: SequenceMatch.Direction = SequenceMatch.Direction(rawValue: jj! - ii!) else {
                i += 1
                continue
            }
            while true {
                let previousComponent: String = components[j - 1]
                let currentComponent: String? = j < components.count ? components[j] : nil
                let previous: Int? = rawComponents.firstIndex(of: previousComponent)
                let current: Int? = currentComponent != nil ? rawComponents.firstIndex(of: currentComponent!) : nil
                if let previous: Int = previous, let current: Int = current,
                    SequenceMatch.Direction(rawValue: current - previous) == direction {
                    j += 1
                } else {
                    if j - i > 2 {
                        let range: ClosedRange<Int> = i...(j - 1)
                        matches.append(SequenceMatch(sequence: rawValue, direction: direction, space: rawComponents.count, range: range, token: components[range].joined()))
                    }
                    break
                }
            }
            i = j
        }
        return matches
    }
}

struct SequenceMatch: Match {
    enum Direction: Int, CaseIterable {
        case forward = 1, reverse = -1
    }
    
    let sequence: String
    let direction: Direction
    let space: Int
    
    // MARK: Match
    let range: ClosedRange<Int>
    let token: String
    let pattern: String = "sequence"
}
