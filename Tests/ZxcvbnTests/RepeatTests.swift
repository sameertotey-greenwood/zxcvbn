import XCTest
@testable import Zxcvbn

final class RepeatTests: XCTestCase {
    
}

extension RepeatTests {
    
    // MARK: Matching
    func testStringMatches() {
        XCTAssertEqual(Repeat().matches("zxcvbn").count, 0)
        XCTAssertEqual(Repeat().matches("qwER43@!").count, 0)
        XCTAssertEqual(Repeat().matches("D0g..................").count, 1)
        XCTAssertEqual(Repeat().matches("D0g..................").first?.entropy ?? -1.0, 9.214319, accuracy: 0.00001)
        XCTAssertEqual(Repeat().matches("aaaEEiiIooooooUU").count, 2)
        XCTAssertEqual(Repeat().matches("aaaEEiiiiIIIooooooUU").count, 4)
        XCTAssertEqual(Repeat().matches("ryanhunter2000").count, 1)
        XCTAssertEqual(Repeat().matches("ryanhunter2000").first?.entropy ?? -1.0, 4.906890, accuracy: 0.00001)
        XCTAssertEqual(Repeat().matches("rianhunter2000").count, 1)
        XCTAssertEqual(Repeat().matches("rianhunter2000").first?.entropy ?? -1.0, 4.906890, accuracy: 0.00001)
        XCTAssertEqual(Repeat().matches("").count, 0)
    }
}
