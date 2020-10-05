import SwiftUI

public struct ResultView: View {
    let result: Result
    
    public init(_ string: String = "", custom: [String] = []) {
        result = string.zxcvbn(custom: custom)
    }
    
    @Environment(\.sizeCategory) private var sizeCategory: ContentSizeCategory
    
    // MARK: View
    public var body: some View {
        HStack(spacing: sizeCategory.length * 0.33) {
            ForEach(Result.Score.allCases) { score in
                if score > .none {
                    RoundedRectangle(cornerRadius: sizeCategory.length * 0.25)
                        .foregroundColor(result.score < score ? Color.secondary.opacity(0.4) : .accentColor)
                        .frame(width: sizeCategory.length, height: sizeCategory.length * 1.1)
                }
            }
        }
        .padding(.horizontal, sizeCategory.length * 0.66)
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView("correcthorsebattery")
    }
}

extension ContentSizeCategory {
    fileprivate var length: CGFloat {
        return UIFontMetrics.default.scaledValue(for: 9.0)
    }
}
