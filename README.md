```
_________________________________________________/\/\___________________
_/\/\/\/\/\__/\/\__/\/\____/\/\/\/\__/\/\__/\/\__/\/\________/\/\/\/\___
_____/\/\______/\/\/\____/\/\________/\/\__/\/\__/\/\/\/\____/\/\__/\/\_
___/\/\________/\/\/\____/\/\__________/\/\/\____/\/\__/\/\__/\/\__/\/\_
_/\/\/\/\/\__/\/\__/\/\____/\/\/\/\______/\______/\/\/\/\____/\/\__/\/\_
________________________________________________________________________
```

`Zxcvbn` attempts to give sound password advice through pattern matching and conservative entropy calculations. It finds 10k common passwords, common American names and surnames, common English words and common patterns like dates, repeats (aaa), sequences (abcd), and QWERTY patterns.

For full motivation, see [zxcvbn: realistic password strength estimation.](https://blogs.dropbox.com/tech/2012/04/zxcvbn-realistic-password-strength-estimation/)

This implementation of `Zxcvbn` for [Swift Package Manager](https://swift.org/package-manager/) carefully matches the evaluation behavior, results and functionality of its ancestors -- while adopting both a new interface and under-the-hood layout.

## Requirements

Targets [iOS](https://developer.apple.com/ios)/[iPadOS](https://developer.apple.com/ipad)/[tvOS ](https://developer.apple.com/tvos) 13, as well as [watchOS](https://developer.apple.com/watchos) 6 and [macOS](https://developer.apple.com/macos) 10.15. Written in [Swift](https://developer.apple.com/documentation/swift) 5.3 requires [Xcode](https://developer.apple.com/xcode) 12 or newer to build. Command-line interface depends on [Swift Argument Parser.](https://github.com/apple/swift-argument-parser)

## Example Usage

Password evaluation is exposed as a function of `String`:

```swift
import Foundation
import Zxcvbn

let result: Result = "coRrecth0rseba++ery9.23.2007staple$".zxcvbn()

print(result.string) // "coRrecth0rseba++ery9.23.2007staple$"
print(result.calculationTime) // 0.289883017539978
print(result.score) // strong
print(result.matches.map { match in
    return "\(match.token)(\(match.pattern))"
}) // ["coRrect(dictionary)", "h0rse(l33t)", "ba++ery(l33t)", "9.23.2007(date)", "staple$(l33t)"]
print(result.crackTime) // 3734821476714185.0
print(result.entropy) // 66.01767308715564
```

Optionally extend the built-in dictionary of common passwords:

```swift
import Foundation
import Zxcvbn

let result: Result = "coRrecth0rseba++ery9.23.2007staple$".zxcvbn(custom: [
    "crailtap",
    "sadplant",
    "mctwist"
])
```

### `UIKit` Additions

![](Zxcvbn.png)

When built for iOS, `Zxcvbn` includes `ResultView`, a replacement for `DBPasswordStrengthMeterView` when moving from the first-party Dropbox [Objective-C implementation.](https://github.com/dropbox/zxcvbn-ios)  `ResultView` inherits the `tintColor` of its parent by default, and adapts to any size given:

```swift
import UIKit
import Zxcvbn

private let resultView: ResultView = ResultView(custom: [])
resultView.addTarget(self, action: #selector(showResultDetail), for: .touchUpInside)
resultView.tintColor = .systemTeal

resultView.string = "coRrecth0rseba++ery9.23.2007staple$"
print(resultView.result!.score) // strong
```

Finally, `Zxcvbn` adds a `UITextField` factory that pre-configures a `ResultView` to live-update as the text value changes. Shove the whole deal into an existing password text field in as little as two lines of code:

```swift
import UIKit
import Zxcvbn

let passwordTextField: CustomAppTextField = ~~CustomAppTextField()~~ .zxcvbn()
passwordTextField.isSecureTextEntry = true
passwordTextField.placeholder = "Password"
```

## Acknowledgments

Ported from the Dropbox [Objective-C implementation](https://github.com/dropbox/zxcvbn-ios) by [Leah Culver.](https://github.com/leah)
