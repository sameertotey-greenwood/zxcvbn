import XCTest
@testable import Zxcvbn

final class IntTests: XCTestCase {
    
}

extension IntTests {
    func testBinomialInit() {
        XCTAssertEqual(Int(binomial: 0, 1), 0)
        XCTAssertEqual(Int(binomial: 0, 0), 1)
        XCTAssertEqual(Int(binomial: 1, 0), 1)
        XCTAssertEqual(Int(binomial: 2, 0), 1)
        XCTAssertEqual(Int(binomial: 4, 1), 4)
        XCTAssertEqual(Int(binomial: 4, 2), 6)
        XCTAssertEqual(Int(binomial: 5, 2), 10)
        XCTAssertEqual(Int(binomial: 7, 2), 21)
    }
}
