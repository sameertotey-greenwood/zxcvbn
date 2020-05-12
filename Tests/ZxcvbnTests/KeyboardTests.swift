import XCTest
@testable import Zxcvbn

final class KeyboardTests: XCTestCase {
    func testAverageDegree() {
        XCTAssertEqual(Keyboard.qwerty.averageDegree, 4.595745, accuracy: 0.000001)
        XCTAssertEqual(Keyboard.dvorak.averageDegree, 4.595745, accuracy: 0.000001)
        XCTAssertEqual(Keyboard.macKeypad.averageDegree, 5.25, accuracy: 0.000001)
        XCTAssertEqual(Keyboard.keypad.averageDegree, 5.066667, accuracy: 0.000001)
    }
    
    func testKeyAdjacencyMap() {
        XCTAssertEqual(Keyboard.qwerty.keyAdjacencyMap.count, 94)
        XCTAssertEqual(Keyboard.dvorak.keyAdjacencyMap.count, 94)
        XCTAssertEqual(Keyboard.macKeypad.keyAdjacencyMap.count, 16)
        XCTAssertEqual(Keyboard.keypad.keyAdjacencyMap.count, 15)
    }
}

extension KeyboardTests {
    
    // MARK: Matching
    func testStringMatches() {
        XCTAssertEqual(Keyboard.dvorak.matches("zxcvbn").count, 0)
        XCTAssertEqual(Keyboard.keypad.matches("zxcvbn").count, 0)
        XCTAssertEqual(Keyboard.macKeypad.matches("zxcvbn").count, 0)
        XCTAssertEqual(Keyboard.qwerty.matches("zxcvbn").count, 1)
        XCTAssertEqual(Keyboard.qwerty.matches("zxcvbn").first?.entropy ?? -1.0, 10.876517, accuracy: 0.00001)
        
        XCTAssertEqual(Keyboard.dvorak.matches("qwER43@!").count, 1)
        XCTAssertEqual(Keyboard.dvorak.matches("qwER43@!").first?.entropy ?? -1.0, 13.598983, accuracy: 0.00001)
        XCTAssertEqual(Keyboard.keypad.matches("qwER43@!").count, 0)
        XCTAssertEqual(Keyboard.macKeypad.matches("qwER43@!").count, 0)
        XCTAssertEqual(Keyboard.qwerty.matches("qwER43@!").count, 1)
        XCTAssertEqual(Keyboard.qwerty.matches("qwER43@!").first?.entropy ?? -1.0, 25.861870, accuracy: 0.00001)
        
        XCTAssertEqual(Keyboard.dvorak.matches("Tr0ub4dour&3").count, 1)
        XCTAssertEqual(Keyboard.dvorak.matches("Tr0ub4dour&3").first?.entropy ?? -1.0, 9.554589, accuracy: 0.00001)
        XCTAssertEqual(Keyboard.keypad.matches("Tr0ub4dour&3").count, 0)
        XCTAssertEqual(Keyboard.macKeypad.matches("Tr0ub4dour&3").count, 0)
        XCTAssertEqual(Keyboard.qwerty.matches("Tr0ub4dour&3").count, 0)
        
        XCTAssertEqual(Keyboard.dvorak.matches("correcthorsebatterystaple").count, 1)
        XCTAssertEqual(Keyboard.dvorak.matches("correcthorsebatterystaple").first?.entropy ?? -1.0, 11.876517, accuracy: 0.00001)
        XCTAssertEqual(Keyboard.keypad.matches("correcthorsebatterystaple").count, 0)
        XCTAssertEqual(Keyboard.macKeypad.matches("correcthorsebatterystaple").count, 0)
        XCTAssertEqual(Keyboard.qwerty.matches("correcthorsebatterystaple").count, 0)
        
        XCTAssertEqual(Keyboard.dvorak.matches("coRrecth0rseba++ery9.23.2007staple$").count, 2)
        XCTAssertEqual(Keyboard.dvorak.matches("coRrecth0rseba++ery9.23.2007staple$").first?.entropy ?? -1.0, 11.876517, accuracy: 0.00001)
        XCTAssertEqual(Keyboard.keypad.matches("coRrecth0rseba++ery9.23.2007staple$").count, 1)
        XCTAssertEqual(Keyboard.keypad.matches("coRrecth0rseba++ery9.23.2007staple$").first?.entropy ?? -1.0, 18.634226, accuracy: 0.00001)
        XCTAssertEqual(Keyboard.macKeypad.matches("coRrecth0rseba++ery9.23.2007staple$").count, 1)
        XCTAssertEqual(Keyboard.macKeypad.matches("coRrecth0rseba++ery9.23.2007staple$").first?.entropy ?? -1.0, 18.634226, accuracy: 0.00001)
        XCTAssertEqual(Keyboard.qwerty.matches("coRrecth0rseba++ery9.23.2007staple$").count, 0)
        
        XCTAssertEqual(Keyboard.dvorak.matches("D0g..................").count, 0)
        XCTAssertEqual(Keyboard.keypad.matches("D0g..................").count, 0)
        XCTAssertEqual(Keyboard.macKeypad.matches("D0g..................").count, 0)
        XCTAssertEqual(Keyboard.qwerty.matches("D0g..................").count, 0)
        
        XCTAssertEqual(Keyboard.dvorak.matches("abcdefghijk987654321").count, 2)
        XCTAssertEqual(Keyboard.dvorak.matches("abcdefghijk987654321").first?.entropy ?? -1.0, 11.876517, accuracy: 0.00001)
        XCTAssertEqual(Keyboard.keypad.matches("abcdefghijk987654321").count, 3)
        XCTAssertEqual(Keyboard.keypad.matches("abcdefghijk987654321").first?.entropy ?? -1.0, 7.228819, accuracy: 0.00001)
        XCTAssertEqual(Keyboard.macKeypad.matches("abcdefghijk987654321").count, 3)
        XCTAssertEqual(Keyboard.macKeypad.matches("abcdefghijk987654321").first?.entropy ?? -1.0, 7.228819, accuracy: 0.00001)
        XCTAssertEqual(Keyboard.qwerty.matches("abcdefghijk987654321").count, 4)
        XCTAssertEqual(Keyboard.qwerty.matches("abcdefghijk987654321").first?.entropy ?? -1.0, 9.554589, accuracy: 0.00001)
        
        XCTAssertEqual(Keyboard.dvorak.matches("neverforget13/3/1997").count, 0)
        XCTAssertEqual(Keyboard.keypad.matches("neverforget13/3/1997").count, 0)
        XCTAssertEqual(Keyboard.macKeypad.matches("neverforget13/3/1997").count, 0)
        XCTAssertEqual(Keyboard.qwerty.matches("neverforget13/3/1997").count, 1)
        XCTAssertEqual(Keyboard.qwerty.matches("neverforget13/3/1997").first?.entropy ?? -1.0, 11.876517, accuracy: 0.00001)
        
        XCTAssertEqual(Keyboard.dvorak.matches("1qaz2wsx3edc").count, 0)
        XCTAssertEqual(Keyboard.keypad.matches("1qaz2wsx3edc").count, 0)
        XCTAssertEqual(Keyboard.macKeypad.matches("1qaz2wsx3edc").count, 0)
        XCTAssertEqual(Keyboard.qwerty.matches("1qaz2wsx3edc").count, 3)
        XCTAssertEqual(Keyboard.qwerty.matches("1qaz2wsx3edc").first?.entropy ?? -1.0, 10.139551, accuracy: 0.00001)
        
        XCTAssertEqual(Keyboard.dvorak.matches("").count, 0)
        XCTAssertEqual(Keyboard.keypad.matches("").count, 0)
        XCTAssertEqual(Keyboard.macKeypad.matches("").count, 0)
        XCTAssertEqual(Keyboard.qwerty.matches("").count, 0)
    }
}
