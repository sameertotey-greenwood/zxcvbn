#if os(iOS)
import UIKit

extension UITextField {
    public static func zxcvbn() -> Self {
        let resultView: ResultView = ResultView()
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
        (rightView as? ResultView)?.result = text?.zxcvbn()
    }
}
#endif
