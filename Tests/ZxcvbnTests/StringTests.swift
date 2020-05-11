import XCTest
@testable import Zxcvbn

final class StringTests: XCTestCase {
    func testCardinality() {
        XCTAssertEqual("zxcvbn".cardinality, 26)
        XCTAssertEqual("qwER43@!".cardinality, 95)
        XCTAssertEqual("correcthorsebatterystaple".cardinality, 26)
        XCTAssertEqual("coRrecth0rseba++ery9.23.2007staple$".cardinality, 95)
        XCTAssertEqual("D0g..................".cardinality, 95)
        XCTAssertEqual("abcdefghijk987654321".cardinality, 36)
        XCTAssertEqual("neverforget13/3/1997".cardinality, 69)
        XCTAssertEqual("ScoRpi0ns".cardinality, 62)
        XCTAssertEqual("do you know".cardinality, 59)
        XCTAssertEqual("rWibMFACxAUGZmxhVncy".cardinality, 52)
        XCTAssertEqual("".cardinality, 0)
    }
}
