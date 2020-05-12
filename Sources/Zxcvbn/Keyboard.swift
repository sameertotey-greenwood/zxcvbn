import Foundation

enum Keyboard: String, CaseIterable {
    case qwerty, dvorak, macKeypad = "mac_keypad", keypad
    
    var averageDegree: Double {
        var total: Int = 0
        for values in keyAdjacencyMap.values {
            total += values.filter { $0 != nil }.count
        }
        return Double(total) / Double(keyAdjacencyMap.count)
    }
    
    var keyCount: Int {
        return keyAdjacencyMap.count
    }
    
    var keyAdjacencyMap: [String: [String?]] {
        if Self.keyAdjacencyMap == nil {
            Self.keyAdjacencyMap = try! JSONDecoder().decode([String: [String: [String?]]].self, from: Keyboard_Data)
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
                        matches.append(KeyboardMatch(turns: turns, shiftedCount: shiftedCount, keyboard: self, range: range, token: "\(components[range].joined())"))
                    }
                    i = j
                    break
                }
            }
        }
        return matches
    }
}

struct KeyboardMatch: Match {
    let turns: Int
    let shiftedCount: Int
    let keyboard: Keyboard
    
    // MARK: Match
    let range: ClosedRange<Int>
    let token: String
    let pattern: String = "keyboard"
    
    var entropy: Double {
        var possibilities: Double = 0.0
        for i in 2..<token.count {
            for j in 1...min(i - 1, self.turns) {
                possibilities += Double(Int(binomial: i - 1, j - 1)) * Double(keyboard.keyCount) * pow(keyboard.averageDegree, Double(j))
            }
        }
        var entropy: Double = log2(possibilities)
        if shiftedCount > 0 {
            let unshiftedCount: Int = token.components.count - shiftedCount
            possibilities = 0.0
            for i in 0...min(shiftedCount, unshiftedCount) {
                possibilities += Double(Int(binomial: shiftedCount + unshiftedCount, i))
            }
            entropy += log2(possibilities)
            
        }
        return entropy
    }
}

private let Keyboard_Data: Data = """
{
    "qwerty": {
        "0": [
            "9(",
            null,
            null,
            "-_",
            "pP",
            "oO"
        ],
        "1": [
            "`~",
            null,
            null,
            "2@",
            "qQ",
            null
        ],
        "2": [
            "1!",
            null,
            null,
            "3#",
            "wW",
            "qQ"
        ],
        "3": [
            "2@",
            null,
            null,
            "4$",
            "eE",
            "wW"
        ],
        "4": [
            "3#",
            null,
            null,
            "5%",
            "rR",
            "eE"
        ],
        "5": [
            "4$",
            null,
            null,
            "6^",
            "tT",
            "rR"
        ],
        "6": [
            "5%",
            null,
            null,
            "7&",
            "yY",
            "tT"
        ],
        "7": [
            "6^",
            null,
            null,
            "8*",
            "uU",
            "yY"
        ],
        "8": [
            "7&",
            null,
            null,
            "9(",
            "iI",
            "uU"
        ],
        "9": [
            "8*",
            null,
            null,
            "0)",
            "oO",
            "iI"
        ],
        "$": [
            "3#",
            null,
            null,
            "5%",
            "rR",
            "eE"
        ],
        "(": [
            "8*",
            null,
            null,
            "0)",
            "oO",
            "iI"
        ],
        ",": [
            "mM",
            "kK",
            "lL",
            ".>",
            null,
            null
        ],
        "<": [
            "mM",
            "kK",
            "lL",
            ".>",
            null,
            null
        ],
        "@": [
            "1!",
            null,
            null,
            "3#",
            "wW",
            "qQ"
        ],
        "D": [
            "sS",
            "eE",
            "rR",
            "fF",
            "cC",
            "xX"
        ],
        "H": [
            "gG",
            "yY",
            "uU",
            "jJ",
            "nN",
            "bB"
        ],
        "L": [
            "kK",
            "oO",
            "pP",
            ";:",
            ".>",
            ",<"
        ],
        "P": [
            "oO",
            "0)",
            "-_",
            "[{",
            ";:",
            "lL"
        ],
        "T": [
            "rR",
            "5%",
            "6^",
            "yY",
            "gG",
            "fF"
        ],
        "X": [
            "zZ",
            "sS",
            "dD",
            "cC",
            null,
            null
        ],
        "\\\\": [
            "]}",
            null,
            null,
            null,
            null,
            null
        ],
        "`": [
            null,
            null,
            null,
            "1!",
            null,
            null
        ],
        "d": [
            "sS",
            "eE",
            "rR",
            "fF",
            "cC",
            "xX"
        ],
        "h": [
            "gG",
            "yY",
            "uU",
            "jJ",
            "nN",
            "bB"
        ],
        "l": [
            "kK",
            "oO",
            "pP",
            ";:",
            ".>",
            ",<"
        ],
        "p": [
            "oO",
            "0)",
            "-_",
            "[{",
            ";:",
            "lL"
        ],
        "t": [
            "rR",
            "5%",
            "6^",
            "yY",
            "gG",
            "fF"
        ],
        "x": [
            "zZ",
            "sS",
            "dD",
            "cC",
            null,
            null
        ],
        "|": [
            "]}",
            null,
            null,
            null,
            null,
            null
        ],
        "#": [
            "2@",
            null,
            null,
            "4$",
            "eE",
            "wW"
        ],
        "'": [
            ";:",
            "[{",
            "]}",
            null,
            null,
            "/?"
        ],
        "+": [
            "-_",
            null,
            null,
            null,
            "]}",
            "[{"
        ],
        "/": [
            ".>",
            ";:",
            "'\\"",
            null,
            null,
            null
        ],
        ";": [
            "lL",
            "pP",
            "[{",
            "'\\"",
            "/?",
            ".>"
        ],
        "?": [
            ".>",
            ";:",
            "'\\"",
            null,
            null,
            null
        ],
        "C": [
            "xX",
            "dD",
            "fF",
            "vV",
            null,
            null
        ],
        "G": [
            "fF",
            "tT",
            "yY",
            "hH",
            "bB",
            "vV"
        ],
        "K": [
            "jJ",
            "iI",
            "oO",
            "lL",
            ",<",
            "mM"
        ],
        "O": [
            "iI",
            "9(",
            "0)",
            "pP",
            "lL",
            "kK"
        ],
        "S": [
            "aA",
            "wW",
            "eE",
            "dD",
            "xX",
            "zZ"
        ],
        "W": [
            "qQ",
            "2@",
            "3#",
            "eE",
            "sS",
            "aA"
        ],
        "[": [
            "pP",
            "-_",
            "=+",
            "]}",
            "'\\"",
            ";:"
        ],
        "_": [
            "0)",
            null,
            null,
            "=+",
            "[{",
            "pP"
        ],
        "c": [
            "xX",
            "dD",
            "fF",
            "vV",
            null,
            null
        ],
        "g": [
            "fF",
            "tT",
            "yY",
            "hH",
            "bB",
            "vV"
        ],
        "k": [
            "jJ",
            "iI",
            "oO",
            "lL",
            ",<",
            "mM"
        ],
        "o": [
            "iI",
            "9(",
            "0)",
            "pP",
            "lL",
            "kK"
        ],
        "s": [
            "aA",
            "wW",
            "eE",
            "dD",
            "xX",
            "zZ"
        ],
        "w": [
            "qQ",
            "2@",
            "3#",
            "eE",
            "sS",
            "aA"
        ],
        "{": [
            "pP",
            "-_",
            "=+",
            "]}",
            "'\\"",
            ";:"
        ],
        "\\"": [
            ";:",
            "[{",
            "]}",
            null,
            null,
            "/?"
        ],
        "&": [
            "6^",
            null,
            null,
            "8*",
            "uU",
            "yY"
        ],
        "*": [
            "7&",
            null,
            null,
            "9(",
            "iI",
            "uU"
        ],
        ".": [
            ",<",
            "lL",
            ";:",
            "/?",
            null,
            null
        ],
        ":": [
            "lL",
            "pP",
            "[{",
            "'\\"",
            "/?",
            ".>"
        ],
        ">": [
            ",<",
            "lL",
            ";:",
            "/?",
            null,
            null
        ],
        "B": [
            "vV",
            "gG",
            "hH",
            "nN",
            null,
            null
        ],
        "F": [
            "dD",
            "rR",
            "tT",
            "gG",
            "vV",
            "cC"
        ],
        "J": [
            "hH",
            "uU",
            "iI",
            "kK",
            "mM",
            "nN"
        ],
        "N": [
            "bB",
            "hH",
            "jJ",
            "mM",
            null,
            null
        ],
        "R": [
            "eE",
            "4$",
            "5%",
            "tT",
            "fF",
            "dD"
        ],
        "V": [
            "cC",
            "fF",
            "gG",
            "bB",
            null,
            null
        ],
        "Z": [
            null,
            "aA",
            "sS",
            "xX",
            null,
            null
        ],
        "^": [
            "5%",
            null,
            null,
            "7&",
            "yY",
            "tT"
        ],
        "b": [
            "vV",
            "gG",
            "hH",
            "nN",
            null,
            null
        ],
        "f": [
            "dD",
            "rR",
            "tT",
            "gG",
            "vV",
            "cC"
        ],
        "j": [
            "hH",
            "uU",
            "iI",
            "kK",
            "mM",
            "nN"
        ],
        "n": [
            "bB",
            "hH",
            "jJ",
            "mM",
            null,
            null
        ],
        "r": [
            "eE",
            "4$",
            "5%",
            "tT",
            "fF",
            "dD"
        ],
        "v": [
            "cC",
            "fF",
            "gG",
            "bB",
            null,
            null
        ],
        "z": [
            null,
            "aA",
            "sS",
            "xX",
            null,
            null
        ],
        "~": [
            null,
            null,
            null,
            "1!",
            null,
            null
        ],
        "!": [
            "`~",
            null,
            null,
            "2@",
            "qQ",
            null
        ],
        "%": [
            "4$",
            null,
            null,
            "6^",
            "tT",
            "rR"
        ],
        ")": [
            "9(",
            null,
            null,
            "-_",
            "pP",
            "oO"
        ],
        "-": [
            "0)",
            null,
            null,
            "=+",
            "[{",
            "pP"
        ],
        "=": [
            "-_",
            null,
            null,
            null,
            "]}",
            "[{"
        ],
        "A": [
            null,
            "qQ",
            "wW",
            "sS",
            "zZ",
            null
        ],
        "E": [
            "wW",
            "3#",
            "4$",
            "rR",
            "dD",
            "sS"
        ],
        "I": [
            "uU",
            "8*",
            "9(",
            "oO",
            "kK",
            "jJ"
        ],
        "M": [
            "nN",
            "jJ",
            "kK",
            ",<",
            null,
            null
        ],
        "Q": [
            null,
            "1!",
            "2@",
            "wW",
            "aA",
            null
        ],
        "U": [
            "yY",
            "7&",
            "8*",
            "iI",
            "jJ",
            "hH"
        ],
        "Y": [
            "tT",
            "6^",
            "7&",
            "uU",
            "hH",
            "gG"
        ],
        "]": [
            "[{",
            "=+",
            null,
            "\\\\|",
            null,
            "'\\""
        ],
        "a": [
            null,
            "qQ",
            "wW",
            "sS",
            "zZ",
            null
        ],
        "e": [
            "wW",
            "3#",
            "4$",
            "rR",
            "dD",
            "sS"
        ],
        "i": [
            "uU",
            "8*",
            "9(",
            "oO",
            "kK",
            "jJ"
        ],
        "m": [
            "nN",
            "jJ",
            "kK",
            ",<",
            null,
            null
        ],
        "q": [
            null,
            "1!",
            "2@",
            "wW",
            "aA",
            null
        ],
        "u": [
            "yY",
            "7&",
            "8*",
            "iI",
            "jJ",
            "hH"
        ],
        "y": [
            "tT",
            "6^",
            "7&",
            "uU",
            "hH",
            "gG"
        ],
        "}": [
            "[{",
            "=+",
            null,
            "\\\\|",
            null,
            "'\\""
        ]
    },
    "dvorak": {
        "0": [
            "9(",
            null,
            null,
            "[{",
            "lL",
            "rR"
        ],
        "1": [
            "`~",
            null,
            null,
            "2@",
            "'\\"",
            null
        ],
        "2": [
            "1!",
            null,
            null,
            "3#",
            ",<",
            "'\\""
        ],
        "3": [
            "2@",
            null,
            null,
            "4$",
            ".>",
            ",<"
        ],
        "4": [
            "3#",
            null,
            null,
            "5%",
            "pP",
            ".>"
        ],
        "5": [
            "4$",
            null,
            null,
            "6^",
            "yY",
            "pP"
        ],
        "6": [
            "5%",
            null,
            null,
            "7&",
            "fF",
            "yY"
        ],
        "7": [
            "6^",
            null,
            null,
            "8*",
            "gG",
            "fF"
        ],
        "8": [
            "7&",
            null,
            null,
            "9(",
            "cC",
            "gG"
        ],
        "9": [
            "8*",
            null,
            null,
            "0)",
            "rR",
            "cC"
        ],
        "$": [
            "3#",
            null,
            null,
            "5%",
            "pP",
            ".>"
        ],
        "(": [
            "8*",
            null,
            null,
            "0)",
            "rR",
            "cC"
        ],
        ",": [
            "'\\"",
            "2@",
            "3#",
            ".>",
            "oO",
            "aA"
        ],
        "<": [
            "'\\"",
            "2@",
            "3#",
            ".>",
            "oO",
            "aA"
        ],
        "@": [
            "1!",
            null,
            null,
            "3#",
            ",<",
            "'\\""
        ],
        "D": [
            "iI",
            "fF",
            "gG",
            "hH",
            "bB",
            "xX"
        ],
        "H": [
            "dD",
            "gG",
            "cC",
            "tT",
            "mM",
            "bB"
        ],
        "L": [
            "rR",
            "0)",
            "[{",
            "/?",
            "sS",
            "nN"
        ],
        "P": [
            ".>",
            "4$",
            "5%",
            "yY",
            "uU",
            "eE"
        ],
        "T": [
            "hH",
            "cC",
            "rR",
            "nN",
            "wW",
            "mM"
        ],
        "X": [
            "kK",
            "iI",
            "dD",
            "bB",
            null,
            null
        ],
        "\\\\": [
            "=+",
            null,
            null,
            null,
            null,
            null
        ],
        "`": [
            null,
            null,
            null,
            "1!",
            null,
            null
        ],
        "d": [
            "iI",
            "fF",
            "gG",
            "hH",
            "bB",
            "xX"
        ],
        "h": [
            "dD",
            "gG",
            "cC",
            "tT",
            "mM",
            "bB"
        ],
        "l": [
            "rR",
            "0)",
            "[{",
            "/?",
            "sS",
            "nN"
        ],
        "p": [
            ".>",
            "4$",
            "5%",
            "yY",
            "uU",
            "eE"
        ],
        "t": [
            "hH",
            "cC",
            "rR",
            "nN",
            "wW",
            "mM"
        ],
        "x": [
            "kK",
            "iI",
            "dD",
            "bB",
            null,
            null
        ],
        "|": [
            "=+",
            null,
            null,
            null,
            null,
            null
        ],
        "#": [
            "2@",
            null,
            null,
            "4$",
            ".>",
            ",<"
        ],
        "'": [
            null,
            "1!",
            "2@",
            ",<",
            "aA",
            null
        ],
        "+": [
            "/?",
            "]}",
            null,
            "\\\\|",
            null,
            "-_"
        ],
        "/": [
            "lL",
            "[{",
            "]}",
            "=+",
            "-_",
            "sS"
        ],
        ";": [
            null,
            "aA",
            "oO",
            "qQ",
            null,
            null
        ],
        "?": [
            "lL",
            "[{",
            "]}",
            "=+",
            "-_",
            "sS"
        ],
        "C": [
            "gG",
            "8*",
            "9(",
            "rR",
            "tT",
            "hH"
        ],
        "G": [
            "fF",
            "7&",
            "8*",
            "cC",
            "hH",
            "dD"
        ],
        "K": [
            "jJ",
            "uU",
            "iI",
            "xX",
            null,
            null
        ],
        "O": [
            "aA",
            ",<",
            ".>",
            "eE",
            "qQ",
            ";:"
        ],
        "S": [
            "nN",
            "lL",
            "/?",
            "-_",
            "zZ",
            "vV"
        ],
        "W": [
            "mM",
            "tT",
            "nN",
            "vV",
            null,
            null
        ],
        "[": [
            "0)",
            null,
            null,
            "]}",
            "/?",
            "lL"
        ],
        "_": [
            "sS",
            "/?",
            "=+",
            null,
            null,
            "zZ"
        ],
        "c": [
            "gG",
            "8*",
            "9(",
            "rR",
            "tT",
            "hH"
        ],
        "g": [
            "fF",
            "7&",
            "8*",
            "cC",
            "hH",
            "dD"
        ],
        "k": [
            "jJ",
            "uU",
            "iI",
            "xX",
            null,
            null
        ],
        "o": [
            "aA",
            ",<",
            ".>",
            "eE",
            "qQ",
            ";:"
        ],
        "s": [
            "nN",
            "lL",
            "/?",
            "-_",
            "zZ",
            "vV"
        ],
        "w": [
            "mM",
            "tT",
            "nN",
            "vV",
            null,
            null
        ],
        "{": [
            "0)",
            null,
            null,
            "]}",
            "/?",
            "lL"
        ],
        "\\"": [
            null,
            "1!",
            "2@",
            ",<",
            "aA",
            null
        ],
        "&": [
            "6^",
            null,
            null,
            "8*",
            "gG",
            "fF"
        ],
        "*": [
            "7&",
            null,
            null,
            "9(",
            "cC",
            "gG"
        ],
        ".": [
            ",<",
            "3#",
            "4$",
            "pP",
            "eE",
            "oO"
        ],
        ":": [
            null,
            "aA",
            "oO",
            "qQ",
            null,
            null
        ],
        ">": [
            ",<",
            "3#",
            "4$",
            "pP",
            "eE",
            "oO"
        ],
        "B": [
            "xX",
            "dD",
            "hH",
            "mM",
            null,
            null
        ],
        "F": [
            "yY",
            "6^",
            "7&",
            "gG",
            "dD",
            "iI"
        ],
        "J": [
            "qQ",
            "eE",
            "uU",
            "kK",
            null,
            null
        ],
        "N": [
            "tT",
            "rR",
            "lL",
            "sS",
            "vV",
            "wW"
        ],
        "R": [
            "cC",
            "9(",
            "0)",
            "lL",
            "nN",
            "tT"
        ],
        "V": [
            "wW",
            "nN",
            "sS",
            "zZ",
            null,
            null
        ],
        "Z": [
            "vV",
            "sS",
            "-_",
            null,
            null,
            null
        ],
        "^": [
            "5%",
            null,
            null,
            "7&",
            "fF",
            "yY"
        ],
        "b": [
            "xX",
            "dD",
            "hH",
            "mM",
            null,
            null
        ],
        "f": [
            "yY",
            "6^",
            "7&",
            "gG",
            "dD",
            "iI"
        ],
        "j": [
            "qQ",
            "eE",
            "uU",
            "kK",
            null,
            null
        ],
        "n": [
            "tT",
            "rR",
            "lL",
            "sS",
            "vV",
            "wW"
        ],
        "r": [
            "cC",
            "9(",
            "0)",
            "lL",
            "nN",
            "tT"
        ],
        "v": [
            "wW",
            "nN",
            "sS",
            "zZ",
            null,
            null
        ],
        "z": [
            "vV",
            "sS",
            "-_",
            null,
            null,
            null
        ],
        "~": [
            null,
            null,
            null,
            "1!",
            null,
            null
        ],
        "!": [
            "`~",
            null,
            null,
            "2@",
            "'\\"",
            null
        ],
        "%": [
            "4$",
            null,
            null,
            "6^",
            "yY",
            "pP"
        ],
        ")": [
            "9(",
            null,
            null,
            "[{",
            "lL",
            "rR"
        ],
        "-": [
            "sS",
            "/?",
            "=+",
            null,
            null,
            "zZ"
        ],
        "=": [
            "/?",
            "]}",
            null,
            "\\\\|",
            null,
            "-_"
        ],
        "A": [
            null,
            "'\\"",
            ",<",
            "oO",
            ";:",
            null
        ],
        "E": [
            "oO",
            ".>",
            "pP",
            "uU",
            "jJ",
            "qQ"
        ],
        "I": [
            "uU",
            "yY",
            "fF",
            "dD",
            "xX",
            "kK"
        ],
        "M": [
            "bB",
            "hH",
            "tT",
            "wW",
            null,
            null
        ],
        "Q": [
            ";:",
            "oO",
            "eE",
            "jJ",
            null,
            null
        ],
        "U": [
            "eE",
            "pP",
            "yY",
            "iI",
            "kK",
            "jJ"
        ],
        "Y": [
            "pP",
            "5%",
            "6^",
            "fF",
            "iI",
            "uU"
        ],
        "]": [
            "[{",
            null,
            null,
            null,
            "=+",
            "/?"
        ],
        "a": [
            null,
            "'\\"",
            ",<",
            "oO",
            ";:",
            null
        ],
        "e": [
            "oO",
            ".>",
            "pP",
            "uU",
            "jJ",
            "qQ"
        ],
        "i": [
            "uU",
            "yY",
            "fF",
            "dD",
            "xX",
            "kK"
        ],
        "m": [
            "bB",
            "hH",
            "tT",
            "wW",
            null,
            null
        ],
        "q": [
            ";:",
            "oO",
            "eE",
            "jJ",
            null,
            null
        ],
        "u": [
            "eE",
            "pP",
            "yY",
            "iI",
            "kK",
            "jJ"
        ],
        "y": [
            "pP",
            "5%",
            "6^",
            "fF",
            "iI",
            "uU"
        ],
        "}": [
            "[{",
            null,
            null,
            null,
            "=+",
            "/?"
        ]
    },
    "mac_keypad": {
        "0": [
            null,
            "1",
            "2",
            "3",
            ".",
            null,
            null,
            null
        ],
        "1": [
            null,
            null,
            "4",
            "5",
            "2",
            "0",
            null,
            null
        ],
        "2": [
            "1",
            "4",
            "5",
            "6",
            "3",
            ".",
            "0",
            null
        ],
        "3": [
            "2",
            "5",
            "6",
            "+",
            null,
            null,
            ".",
            "0"
        ],
        "4": [
            null,
            null,
            "7",
            "8",
            "5",
            "2",
            "1",
            null
        ],
        "5": [
            "4",
            "7",
            "8",
            "9",
            "6",
            "3",
            "2",
            "1"
        ],
        "6": [
            "5",
            "8",
            "9",
            "-",
            "+",
            null,
            "3",
            "2"
        ],
        "7": [
            null,
            null,
            null,
            "=",
            "8",
            "5",
            "4",
            null
        ],
        "8": [
            "7",
            null,
            "=",
            "/",
            "9",
            "6",
            "5",
            "4"
        ],
        "9": [
            "8",
            "=",
            "/",
            "*",
            "-",
            "+",
            "6",
            "5"
        ],
        "+": [
            "6",
            "9",
            "-",
            null,
            null,
            null,
            null,
            "3"
        ],
        "*": [
            "/",
            null,
            null,
            null,
            null,
            null,
            "-",
            "9"
        ],
        "-": [
            "9",
            "/",
            "*",
            null,
            null,
            null,
            "+",
            "6"
        ],
        "/": [
            "=",
            null,
            null,
            null,
            "*",
            "-",
            "9",
            "8"
        ],
        ".": [
            "0",
            "2",
            "3",
            null,
            null,
            null,
            null,
            null
        ],
        "=": [
            null,
            null,
            null,
            null,
            "/",
            "9",
            "8",
            "7"
        ]
    },
    "keypad": {
        "0": [
            null,
            "1",
            "2",
            "3",
            ".",
            null,
            null,
            null
        ],
        "1": [
            null,
            null,
            "4",
            "5",
            "2",
            "0",
            null,
            null
        ],
        "2": [
            "1",
            "4",
            "5",
            "6",
            "3",
            ".",
            "0",
            null
        ],
        "3": [
            "2",
            "5",
            "6",
            null,
            null,
            null,
            ".",
            "0"
        ],
        "4": [
            null,
            null,
            "7",
            "8",
            "5",
            "2",
            "1",
            null
        ],
        "5": [
            "4",
            "7",
            "8",
            "9",
            "6",
            "3",
            "2",
            "1"
        ],
        "6": [
            "5",
            "8",
            "9",
            "+",
            null,
            null,
            "3",
            "2"
        ],
        "7": [
            null,
            null,
            null,
            "/",
            "8",
            "5",
            "4",
            null
        ],
        "8": [
            "7",
            null,
            "/",
            "*",
            "9",
            "6",
            "5",
            "4"
        ],
        "9": [
            "8",
            "/",
            "*",
            "-",
            "+",
            null,
            "6",
            "5"
        ],
        "+": [
            "9",
            "*",
            "-",
            null,
            null,
            null,
            null,
            "6"
        ],
        "*": [
            "/",
            null,
            null,
            null,
            "-",
            "+",
            "9",
            "8"
        ],
        "-": [
            "*",
            null,
            null,
            null,
            null,
            null,
            "+",
            "9"
        ],
        "/": [
            null,
            null,
            null,
            null,
            "*",
            "9",
            "8",
            "7"
        ],
        ".": [
            "0",
            "2",
            "3",
            null,
            null,
            null,
            null,
            null
        ]
    }
}
""".data(using: .utf8)!
