import Foundation

public enum Keyboard: String, CaseIterable {
    case qwerty, dvorak, macKeypad = "mac_keypad", keypad
    
    var averageDegree: Int {
        var total: Int = 0
        for values in keyAdjacencyMap.values {
            total += values.filter { $0 != nil }.count
        }
        return total / keyAdjacencyMap.count
    }
    
    var keyCount: Int {
        return keyAdjacencyMap.count
    }
    
    var keyAdjacencyMap: [String: [String?]] {
        if Self.keyAdjacencyMap == nil {
            let url: URL = Bundle.module.url(forResource: "Keyboard", withExtension: "json")!
            Self.keyAdjacencyMap = try! JSONDecoder().decode([String: [String: [String?]]].self, from: try! Data(contentsOf: url))
        }
        return Self.keyAdjacencyMap![rawValue]!
    }
    
    private static var keyAdjacencyMap: [String: [String: [String?]]]?
}

extension Keyboard: Matching {
    
    // MARK: Matching
    func matches(_ string: String) -> [Match] {
        let adjacencyMap: [String: [String?]] = self.keyAdjacencyMap
        let components: [String] = string.components
        var matches: [KeyboardMatch] = []
        var i: Int = 0
        while i < string.count - 1 {
            var j: Int = i + 1
            var lastDirection: Int = -1
            var turns: Int = 0
            var shiftedCount: Int = 0
            while true {
                let adjacentKeys: [String?] = adjacencyMap[components[j - 1]] ?? []
                var found: Bool = false
                var foundDirection: Int = -1
                var currentDirection: Int = -1
                if j < string.count {
                    let current: String  = components[j]
                    for adjacentKey in adjacentKeys {
                        currentDirection += 1
                        guard let adjacentKey: String = adjacentKey, adjacentKey.contains(current) else {
                            continue
                        }
                        let adjacentComponents: [String] = adjacentKey.components
                        found = true
                        foundDirection = currentDirection
                        if adjacentComponents.last == current {
                            shiftedCount += 1
                        }
                        if lastDirection != foundDirection {
                            turns += 1
                            lastDirection = foundDirection
                        }
                        break
                    }
                }
                if found {
                    j += 1
                } else {
                    if j - i > 2 {
                        let range: ClosedRange<Int> = i...(j - 1)
                        matches.append(KeyboardMatch(keyboard: self, shiftedCount: shiftedCount, turns: turns, range: range, token: "\(components[range].joined())"))
                    }
                    i = j
                    break
                }
            }
        }
        return matches
    }
}

public struct KeyboardMatch: Match {
    public let keyboard: Keyboard
    let shiftedCount: Int
    let turns: Int
    
    // MARK: Match
    public let pattern: String = "keyboard"
    public let range: ClosedRange<Int>
    public let token: String
    
    public var entropy: Double {
        var possibilities: Double = 0.0
        for i in 2...token.count {
            for j in 1...min(i - 1, self.turns) {
                possibilities += Double(binomial: i - 1, j - 1) * Double(keyboard.keyCount) * pow(Double(keyboard.averageDegree), Double(j))
            }
        }
        var entropy: Double = log2(possibilities)
        if shiftedCount > 0 {
            let unshiftedCount: Int = token.components.count - shiftedCount
            possibilities = 0.0
            for i in 0...min(shiftedCount, unshiftedCount) {
                possibilities += Double(binomial: shiftedCount + unshiftedCount, i)
            }
            entropy += log2(possibilities)
        }
        return entropy
    }
}
