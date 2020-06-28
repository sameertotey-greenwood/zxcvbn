import Foundation

extension TimeInterval {
    var formatted: String {
        return 3155760000.0 > self ? Self.formatter.string(from: self)! : "100yrs+"
    }
    
    private static let formatter: DateComponentsFormatter = DateComponentsFormatter(style: .brief)
}

extension DateComponentsFormatter {
    convenience init(style: UnitsStyle) {
        self.init()
        self.unitsStyle = style
    }
}
