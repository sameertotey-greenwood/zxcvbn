import Foundation

extension String {
    public func zxcvbn(custom: [String] = []) -> Result {
        return Result(string: self, matching: [
            Dictionary.custom(custom),
            Dictionary.allCases,
            L33t(dictionaries: [
                Dictionary.custom(custom)
            ] + Dictionary.allCases),
            Pattern.allCases,
            Repeat(),
            Sequence.allCases,
            [
                Keyboard.qwerty,
                Keyboard.keypad
            ]
        ])
    }
    
    var cardinality: Int {
        var cardinality: [Int] = [0, 0, 0, 0]
        for component in components {
            if "abcdefghijklmnopqrstuvwxyz".contains(component) {
                cardinality[0] = 26
            } else if "ABCDEFGHIJKLMNOPQRSTUVWXYZ".contains(component) {
                cardinality[1] = 26
            } else if "0123456789".contains(component) {
                cardinality[2] = 10
            } else {
                cardinality[3] = 33
            }
        }
        return cardinality.reduce(0, +)
    }
    
    var components: [String] {
        return map { "\($0)" }
    }
}
