import Foundation
import ArgumentParser
import Zxcvbn

struct ZxcvbnCLI: ParsableCommand {
    @Argument(help: "Specify a string to evaluate.")
    var string: String
    
    // MARK: ParsableCommand
    static var configuration = CommandConfiguration(abstract: "Evaluate the fitness of any string for use as a password.")
    
    func run() throws {
        let result: Result = string.zxcvbn()
        print("STRING: \"\(result.string)\"")
        print("")
        print("SCORE:")
        for score in Result.Score.allCases.reversed() {
            print("  \(score == result.score ? "◼︎" : "◻︎") \(score.rawValue) - \(score)")
        }
        print("")
        print("MATCHES:")
        for match in result.matches.filter({ ($0 as? BruteForceMatch) == nil }) {
            let token: String = "\"\(match.token.prefix(14))\""
            print("  \(token)\(String(repeating: " ", count: 16 - token.count))  \(match.pattern)")
        }
        print("")
        print("CRACK TIME: \(result.crackTime.formatted)")
        print("")
    }
}

ZxcvbnCLI.main()
