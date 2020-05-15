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
        XCTAssertEqual(Dictionary.allCases.matches("zxcvbn").count, 3)
        XCTAssertEqual(Dictionary.allCases.matches("zxcvbn").first?.entropy ?? -1.0, 10.005625, accuracy: 0.00001)
        XCTAssertEqual(Dictionary.allCases.matches("qwER43@!").count, 2)
        XCTAssertEqual(Dictionary.allCases.matches("qwER43@!").first?.entropy ?? -1.0, 12.814783, accuracy: 0.00001)
        XCTAssertEqual(Dictionary.allCases.matches("correcthorsebatterystaple").count, 21)
        XCTAssertEqual(Dictionary.allCases.matches("correcthorsebatterystaple").first?.entropy ?? -1.0, 10.688250, accuracy: 0.00001)
        XCTAssertEqual(Dictionary.allCases.matches("coRrecth0rseba++ery9.23.2007staple$").count, 10)
        XCTAssertEqual(Dictionary.allCases.matches("coRrecth0rseba++ery9.23.2007staple$").first?.entropy ?? -1.0, 14.688469, accuracy: 0.00001)
        XCTAssertEqual(Dictionary.allCases.matches("neverforget13/3/1997").count, 11)
        XCTAssertEqual(Dictionary.allCases.matches("neverforget13/3/1997").first?.entropy ?? -1.0, 11.861862, accuracy: 0.00001)
        XCTAssertEqual(Dictionary.allCases.matches("abcdefghijk987654321").count, 20)
        XCTAssertEqual(Dictionary.allCases.matches("abcdefghijk987654321").first?.entropy ?? -1.0, 9.257388, accuracy: 0.00001)
        XCTAssertEqual(Dictionary.allCases.matches("briansmith").count, 11)
        XCTAssertEqual(Dictionary.allCases.matches("briansmith").first?.entropy ?? -1.0, 14.136030, accuracy: 0.00001)
        XCTAssertEqual(Dictionary.allCases.matches("briansmith4mayor").count, 16)
        XCTAssertEqual(Dictionary.allCases.matches("briansmith4mayor").first?.entropy ?? -1.0, 14.136030, accuracy: 0.00001)
        XCTAssertEqual(Dictionary.allCases.matches("password1").count, 12)
        XCTAssertEqual(Dictionary.allCases.matches("password1").first?.entropy ?? -1.0, 5.129283, accuracy: 0.00001)
        XCTAssertEqual(Dictionary.allCases.matches("viking").count, 8)
        XCTAssertEqual(Dictionary.allCases.matches("viking").first?.entropy ?? -1.0, 7.531381, accuracy: 0.00001)
        XCTAssertEqual(Dictionary.allCases.matches("do you know").count, 5)
        XCTAssertEqual(Dictionary.allCases.matches("do you know").first?.entropy ?? -1.0, 4.584963, accuracy: 0.00001)
        XCTAssertEqual(Dictionary.allCases.matches("ryanhunter2000").count, 12)
        XCTAssertEqual(Dictionary.allCases.matches("ryanhunter2000").first?.entropy ?? -1.0, 4.643856, accuracy: 0.00001)
        XCTAssertEqual(Dictionary.allCases.matches("rianhunter2000").count, 12)
        XCTAssertEqual(Dictionary.allCases.matches("rianhunter2000").first?.entropy ?? -1.0, 4.643856, accuracy: 0.00001)
        XCTAssertEqual(Dictionary.allCases.matches("rosebud").count, 4)
        XCTAssertEqual(Dictionary.allCases.matches("rosebud").first?.entropy ?? -1.0, 7.936638, accuracy: 0.00001)
        XCTAssertEqual(Dictionary.allCases.matches("Rosebud").count, 4)
        XCTAssertEqual(Dictionary.allCases.matches("Rosebud").first?.entropy ?? -1.0, 8.936638, accuracy: 0.00001)
        XCTAssertEqual(Dictionary.allCases.matches("ROSEBUD").count, 4)
        XCTAssertEqual(Dictionary.allCases.matches("ROSEBUD").first?.entropy ?? -1.0, 7.936638, accuracy: 0.00001)
        XCTAssertEqual(Dictionary.allCases.matches("rosebuD").count, 4)
        XCTAssertEqual(Dictionary.allCases.matches("rosebuD").first?.entropy ?? -1.0, 8.936638, accuracy: 0.00001)
        XCTAssertEqual(Dictionary.allCases.matches("ros3bud99").count, 2)
        XCTAssertEqual(Dictionary.allCases.matches("ros3bud99").first?.entropy ?? -1.0, 13.675626, accuracy: 0.00001)
        
        XCTAssertEqual(Dictionary.passwords.matches("zxcvbn").count, 3)
        XCTAssertEqual(Dictionary.passwords.matches("zxcvbn").first?.entropy ?? -1.0, 10.005625, accuracy: 0.00001)
        XCTAssertEqual(Dictionary.femaleNames.matches("zxcvbn").count, 0)
        XCTAssertEqual(Dictionary.surnames.matches("zxcvbn").count, 0)
        XCTAssertEqual(Dictionary.maleNames.matches("zxcvbn").count, 0)
        
        XCTAssertEqual(Dictionary.custom(["zxcvbn"]).matches("zxcvbn").count, 1)
        XCTAssertEqual(Dictionary.custom(["zxcvbn"]).matches("zxcvbn").first?.entropy ?? -1.0, 0.0, accuracy: 0.00001)
        XCTAssertEqual(Dictionary.custom(["dvorak"]).matches("zxcvbn").count, 0)
        XCTAssertEqual(Dictionary.custom(["dvorak"]).matches("dvorak").count, 1)
        XCTAssertEqual(Dictionary.custom(["dvorak"]).matches("dvorak").first?.entropy ?? -1.0, 0.0, accuracy: 0.00001)
    }
}
