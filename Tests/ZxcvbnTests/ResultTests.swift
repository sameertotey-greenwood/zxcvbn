import XCTest
@testable import Zxcvbn

final class ResultTests: XCTestCase {
    func testScoreInit() {
        XCTAssertEqual(Result.Score(0.006), .none)
        XCTAssertEqual(Result.Score(3049.078), .insufficient)
        XCTAssertEqual(Result.Score(72600.57), .weak)
        XCTAssertEqual(Result.Score(2037202560.0), .strong)
        XCTAssertEqual(Result.Score(2489877635530752.0), .strong)
        XCTAssertEqual(Result.Score(331974.562), .weak)
        XCTAssertEqual(Result.Score(237.363), .insufficient)
        XCTAssertEqual(Result.Score(20.43), .none)
        XCTAssertEqual(Result.Score(1486129174880935117779369984.0), .strong)
    }
    
    func testInit() {
        let matching: [Matching] = [
            Dictionary.allCases,
            L33t(dictionaries: Dictionary.allCases),
            Pattern.allCases,
            Repeat(),
            Sequence.allCases,
            [
                Keyboard.qwerty,
                Keyboard.keypad
            ]
        ]
        
        var result: Result = Result(string: "zxcvbn", matching: matching)
        XCTAssertEqual(result.string, "zxcvbn")
        XCTAssertEqual(result.entropy, 6.8455, accuracy: 0.0001)
        XCTAssertEqual(result.crackTime, 0.0057, accuracy: 0.0001)
        XCTAssertEqual(result.score, .none)
        
        result = Result(string: "qwER43@!", matching: matching)
        XCTAssertEqual(result.string, "qwER43@!")
        XCTAssertEqual(result.entropy, 25.8619, accuracy: 0.0001)
        XCTAssertEqual(result.crackTime, 3049.078, accuracy: 0.0001)
        XCTAssertEqual(result.score, .insufficient)
        
        result = Result(string: "Tr0ub4dour&3", matching: matching)
        XCTAssertEqual(result.string, "Tr0ub4dour&3")
        XCTAssertEqual(result.entropy, 30.4354, accuracy: 0.0001)
        XCTAssertEqual(result.crackTime, 72600.71, accuracy: 0.0001)
        XCTAssertEqual(result.score, .weak)
        
        result = Result(string: "correcthorsebatterystaple", matching: matching)
        XCTAssertEqual(result.string, "correcthorsebatterystaple")
        XCTAssertEqual(result.entropy, 45.2117, accuracy: 0.0001)
        XCTAssertEqual(result.crackTime, 2037200406.4749, accuracy: 0.0001)
        XCTAssertEqual(result.score, .strong)
        
        result = Result(string: "coRrecth0rseba++ery9.23.2007staple$", matching: matching)
        XCTAssertEqual(result.string, "coRrecth0rseba++ery9.23.2007staple$")
        XCTAssertEqual(result.entropy, 66.0177, accuracy: 0.0001)
        XCTAssertEqual(result.crackTime, 3734821476714185.0, accuracy: 0.0001)
        XCTAssertEqual(result.score, .strong)
        
        result = Result(string: "neverforget13/3/1997", matching: matching)
        XCTAssertEqual(result.string, "neverforget13/3/1997")
        XCTAssertEqual(result.entropy, 32.6284, accuracy: 0.0001)
        XCTAssertEqual(result.crackTime, 331974.5856, accuracy: 0.0001)
        XCTAssertEqual(result.score, .weak)
        
        result = Result(string: "temppass22", matching: matching)
        XCTAssertEqual(result.string, "temppass22")
        XCTAssertEqual(result.entropy, 22.1787, accuracy: 0.0001)
        XCTAssertEqual(result.crackTime, 237.3624, accuracy: 0.0001)
        XCTAssertEqual(result.score, .insufficient)
        
        result = Result(string: "briansmith4mayor", matching: matching)
        XCTAssertEqual(result.string, "briansmith4mayor")
        XCTAssertEqual(result.entropy, 18.6403, accuracy: 0.0001)
        XCTAssertEqual(result.crackTime, 20.43, accuracy: 0.0001)
        XCTAssertEqual(result.score, .none)
        
        result = Result(string: "rWibMFACxAUGZmxhVncy", matching: matching)
        XCTAssertEqual(result.string, "rWibMFACxAUGZmxhVncy")
        XCTAssertEqual(result.entropy, 104.5513, accuracy: 0.0001)
        XCTAssertEqual(result.crackTime, 1486130138821666600000000000.0, accuracy: 0.0001)
        XCTAssertEqual(result.score, .strong)
    }
}
