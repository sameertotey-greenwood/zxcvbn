import XCTest
@testable import Zxcvbn

final class PatternTests: XCTestCase {
    
}

extension PatternTests {
    
    // MARK: Matching
    func testStringMatches() {
        XCTAssertEqual(Pattern.date.matches("zxcvbn").count, 0)
        XCTAssertEqual(Pattern.year.matches("zxcvbn").count, 0)
        XCTAssertEqual(Pattern.digits.matches("zxcvbn").count, 0)
        
        XCTAssertEqual(Pattern.date.matches("coRrecth0rseba++ery9.23.2007staple$").count, 1)
        XCTAssertEqual(Pattern.year.matches("coRrecth0rseba++ery9.23.2007staple$").count, 1)
        XCTAssertEqual(Pattern.digits.matches("coRrecth0rseba++ery9.23.2007staple$").count, 1)
        
        XCTAssertEqual(Pattern.date.matches("D0g..................").count, 0)
        XCTAssertEqual(Pattern.year.matches("D0g..................").count, 0)
        XCTAssertEqual(Pattern.digits.matches("D0g..................").count, 0)
        
        XCTAssertEqual(Pattern.date.matches("abcdefghijk987654321").count, 1)
        XCTAssertEqual(Pattern.year.matches("abcdefghijk987654321").count, 0)
        XCTAssertEqual(Pattern.digits.matches("abcdefghijk987654321").count, 1)
        
        XCTAssertEqual(Pattern.date.matches("neverforget13/3/1997").count, 1)
        XCTAssertEqual(Pattern.year.matches("neverforget13/3/1997").count, 1)
        XCTAssertEqual(Pattern.digits.matches("neverforget13/3/1997").count, 1)
        
        XCTAssertEqual(Pattern.date.matches("thx1138").count, 1)
        XCTAssertEqual(Pattern.year.matches("thx1138").count, 0)
        XCTAssertEqual(Pattern.digits.matches("thx1138").count, 1)
        
        XCTAssertEqual(Pattern.date.matches("ryanhunter2000").count, 1)
        XCTAssertEqual(Pattern.year.matches("ryanhunter2000").count, 1)
        XCTAssertEqual(Pattern.digits.matches("ryanhunter2000").count, 1)
        
        XCTAssertEqual(Pattern.date.matches("defghi6789").count, 1)
        XCTAssertEqual(Pattern.year.matches("defghi6789").count, 0)
        XCTAssertEqual(Pattern.digits.matches("defghi6789").count, 1)
        
        XCTAssertEqual(Pattern.date.matches("").count, 0)
        XCTAssertEqual(Pattern.year.matches("").count, 0)
        XCTAssertEqual(Pattern.digits.matches("").count, 0)
    }
}
