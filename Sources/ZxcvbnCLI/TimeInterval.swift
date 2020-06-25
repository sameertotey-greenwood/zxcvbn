import Foundation

extension TimeInterval {
    var formatted: String {
        return Self.formatter.string(from: self)!
    }
    
    private static let formatter: DateComponentsFormatter = DateComponentsFormatter(style: .brief)
}

extension DateComponentsFormatter {
    convenience init(style: UnitsStyle) {
        self.init()
        self.unitsStyle = style
    }
}
