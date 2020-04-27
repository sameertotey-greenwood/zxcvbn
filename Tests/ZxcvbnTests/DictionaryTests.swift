import XCTest
@testable import Zxcvbn

final class DictionaryTests: XCTestCase {
    func testRanked() {
        //XCTAssertEqual(Dictionary.passwords.ranked, 7141)
        XCTAssertEqual(Dictionary.passwords.ranked.count, 7141)
        XCTAssertEqual(Dictionary.english.ranked.count, 32545)
        XCTAssertEqual(Dictionary.femaleNames.ranked.count, 3815)
        XCTAssertEqual(Dictionary.surnames.ranked.count, 40583)
        XCTAssertEqual(Dictionary.maleNames.ranked.count, 1004)
        //XCTAssertEqual(Dictionary.custom(["custom"]).ranked, 1)
        XCTAssertEqual(Dictionary.custom(["custom"]).ranked.count, 1)
    }
    
    // MARK: RawRepresentable
    func testRawValue() {
        XCTAssertEqual(Dictionary.passwords.rawValue, "passwords")
        XCTAssertEqual(Dictionary.english.rawValue, "english")
        XCTAssertEqual(Dictionary.femaleNames.rawValue, "female_names")
        XCTAssertEqual(Dictionary.surnames.rawValue, "surnames")
        XCTAssertEqual(Dictionary.maleNames.rawValue, "male_names")
        XCTAssertEqual(Dictionary.custom([]).rawValue, "custom")
    }
    
    // MARK: CaseIterable
    func testAllCases() {
        XCTAssertEqual(Dictionary.allCases, [.passwords, .english, .femaleNames, .surnames, .maleNames])
    }
}

extension DictionaryTests {
    
    // MARK: Matching
    func testStringMatches() {
        XCTAssertEqual(Dictionary.passwords.matches("zxcvbn").count, 3)
        XCTAssertEqual(Dictionary.femaleNames.matches("zxcvbn").count, 0)
        XCTAssertEqual(Dictionary.surnames.matches("zxcvbn").count, 0)
        XCTAssertEqual(Dictionary.maleNames.matches("zxcvbn").count, 0)
        XCTAssertEqual(Dictionary.custom(["zxcvbn"]).matches("zxcvbn").count, 1)
        XCTAssertEqual(Dictionary.custom(["dvorak"]).matches("zxcvbn").count, 0)
        XCTAssertEqual(Dictionary.custom(["dvorak"]).matches("dvorak").count, 1)
    }
}
