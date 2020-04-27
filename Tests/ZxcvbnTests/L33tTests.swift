import XCTest
@testable import Zxcvbn

final class L33tTests: XCTestCase {
    func testSubstitutionTable() {
        XCTAssertEqual(L33t.substitutionTable.count, 12)
        XCTAssertEqual(L33t.substitutionTable("abcegilostxz").count, 12)
        XCTAssertEqual(L33t.substitutionTable("qwerty").count, 2)
        XCTAssertEqual(L33t.substitutionTable("asdfgh").count, 3)
        XCTAssertEqual(L33t.substitutionTable("zxcvbn").count, 4)
        XCTAssertEqual(L33t.substitutionTable("").count, 0)
    }
}

extension L33tTests {
    
}
