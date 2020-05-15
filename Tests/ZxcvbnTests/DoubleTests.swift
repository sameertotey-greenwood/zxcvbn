import XCTest
@testable import Zxcvbn

final class DoubleTests: XCTestCase {
    
}

extension DoubleTests {
    func testBinomialInit() {
        XCTAssertEqual(Double(binomial: 0, 1), 0.0)
        XCTAssertEqual(Double(binomial: 0, 0), 1.0)
        XCTAssertEqual(Double(binomial: 1, 0), 1.0)
        XCTAssertEqual(Double(binomial: 2, 0), 1.0)
        XCTAssertEqual(Double(binomial: 4, 1), 4.0)
        XCTAssertEqual(Double(binomial: 4, 2), 6.0)
        XCTAssertEqual(Double(binomial: 5, 2), 10.0)
        XCTAssertEqual(Double(binomial: 7, 2), 21.0)
    }
}
