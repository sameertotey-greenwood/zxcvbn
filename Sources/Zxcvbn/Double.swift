import Foundation

extension Double {
    init(binomial n: Int, _ k: Int) {
        if k > n {
            self = 0.0
        } else if k == 0 {
            self = 1.0
        } else {
            var n: Int = n
            var i: Double = 1.0
            for d in 1...k {
                i *= Double(n)
                i /= Double(d)
                n -= 1
            }
            self = i
        }
    }
}
