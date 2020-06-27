#if os(iOS)
import UIKit

extension UITextField {
    public static func zxcvbn(custom: [String] = []) -> Self {
        let resultView: ResultView = ResultView(custom: custom)
        resultView.autoresizingMask = [.flexibleHeight]
        resultView.frame.size.height = 31.0
        resultView.frame.size.width = 12.0
        
        let textField: Self = Self()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.rightView = resultView
        textField.rightViewMode = .always
        
        NotificationCenter.default.addObserver(textField, selector: #selector(textDidChange(_:)), name: Self.textDidChangeNotification, object: textField)
        
        return textField
    }
    
    @objc private func textDidChange(_ notification: Notification) {
        guard notification.object as? Self == self else {
            return
        }
        (rightView as? ResultView)?.string = text
    }
}
#endif
