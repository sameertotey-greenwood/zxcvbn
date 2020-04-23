import XCTest
@testable import Zxcvbn

final class KeyboardTests: XCTestCase {
    func testKeyAdjacencyMap() {
        XCTAssertEqual(Keyboard.qwerty.keyAdjacencyMap.count, 94)
        XCTAssertEqual(Keyboard.dvorak.keyAdjacencyMap.count, 94)
        XCTAssertEqual(Keyboard.macKeypad.keyAdjacencyMap.count, 16)
        XCTAssertEqual(Keyboard.keypad.keyAdjacencyMap.count, 15)
    }
}
