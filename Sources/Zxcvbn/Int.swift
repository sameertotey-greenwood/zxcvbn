import Foundation

extension Int {
    init(binomial n: Int, _ k: Int) {
        
        // http://blog.plover.com/math/choose.html
        if k > n {
            self = 0
        } else if k == 0 {
            self = 1
        } else {
            var n: Int = n
            var i: Int = 1
            for d in 1...k {
                i *= n
                i /= d
                n -= 1
            }
            self = i
        }
    }
}
