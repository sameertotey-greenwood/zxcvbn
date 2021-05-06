import SwiftUI

public struct ResultView: View {
    let result: Result
    
    public init(_ string: String = "", custom: [String] = []) {
        result = string.zxcvbn(custom: custom)
    }
    
    private var length: CGFloat {
        let value: CGFloat = 9.0
#if canImport(UIFontMetrics)
        return UIFontMetrics.default.scaledValue(for: value)
#else
        return value
#endif
    }
    
    // MARK: View
    public var body: some View {
        HStack(spacing: length * 0.33) {
            ForEach(Result.Score.allCases) { score in
                if score > .none {
                    RoundedRectangle(cornerRadius: length * 0.25)
                        .foregroundColor(result.score < score ? Color.secondary.opacity(0.4) : .accentColor)
                        .frame(width: length, height: length * 1.1)
                }
            }
        }
        .padding(.horizontal, length * 0.66)
    }
}

struct ResultView_Previews: PreviewProvider {
    @State static var text: String = ""
    
    static var previews: some View {
        SecureField("Password", text: $text)
            .overlay(ResultView(text), alignment: .trailing)
            .padding()
    }
}
