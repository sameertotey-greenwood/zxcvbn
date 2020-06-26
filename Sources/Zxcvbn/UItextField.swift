#if os(iOS)
import UIKit

extension UITextField {
    public static func zxcvbn(custom: [String] = []) -> Self {
        let resultView: ResultView = ResultView(custom: custom)
        resultView.autoresizingMask = [.flexibleHeight]
        resultView.frame.size.height = 31.0
        resultView.frame.size.width = 12.0
        
        let textField: Self = Self()
        textField.rightView = resultView
        textField.rightViewMode = .always
        
        NotificationCenter.default.addObserver(textField, selector: #selector(textDidChange(_:)), name: Self.textDidChangeNotification, object: nil)
        
        return textField
    }
    
    @objc private func textDidChange(_ notification: Notification) {
        (rightView as? ResultView)?.string = text
    }
}
#endif
