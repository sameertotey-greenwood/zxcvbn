import Foundation

struct L33t {
    static var substitutionTable: [String: [String]] {
        return try! JSONDecoder().decode([String: [String]].self, from: L33t_Data)
    }
    
    static func substitutionTable(_ string: String) -> [String: [String]] {
        return substitutionTable.filter { key, _ in
            return string.contains(key)
        }
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
