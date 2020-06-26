#if os(iOS)
import UIKit

public class ResultView: UIControl {
    public private(set) var custom: [String] = []
    public private(set) var result: Result?
    
    public var string: String? = nil {
        didSet {
            result = string?.zxcvbn(custom: custom)
            setNeedsLayout()
        }
    }
    
    public convenience init(custom: [String]) {
        self.init(frame: .zero)
        self.custom = custom
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private let scoreView: UIView = UIView()
    private let scoreSprites: [ScoreSprite] = Result.Score.allCases.compactMap { score in
        return score != .none ? ScoreSprite() : nil
    }
    
    private func setUp() {
        scoreView.isUserInteractionEnabled = false
        scoreView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scoreView.frame = bounds
        addSubview(scoreView)
        
        for scoreSprite in scoreSprites {
            scoreView.addSubview(scoreSprite)
        }
    }
    
    // MARK: UIControl
    public override var isHighlighted: Bool {
        didSet {
            scoreView.alpha = (isEnabled && allControlEvents.rawValue != 0 && isHighlighted) ? 0.42 : 1.0
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        for (index, scoreSprite) in scoreSprites.enumerated() {
            if bounds.size.width > bounds.size.height {
                scoreSprite.frame.origin.y = (bounds.size.width * 0.25) / CGFloat(scoreSprites.count + 1)
                scoreSprite.frame.size.width = (bounds.size.width * 0.75) / CGFloat(scoreSprites.count)
                scoreSprite.frame.size.height = bounds.size.height - (scoreSprite.frame.origin.y * 2.0)
                scoreSprite.frame.origin.x = scoreSprite.frame.origin.y + ((scoreSprite.frame.size.width + scoreSprite.frame.origin.y) * CGFloat(index))
            } else {
                scoreSprite.frame.origin.x = (bounds.size.height * 0.25) / CGFloat(scoreSprites.count + 1)
                scoreSprite.frame.size.width = bounds.size.width - (scoreSprite.frame.origin.x * 2.0)
                scoreSprite.frame.size.height = (bounds.size.height * 0.75) / CGFloat(scoreSprites.count)
                scoreSprite.frame.origin.y = bounds.size.height - ((scoreSprite.frame.size.height + scoreSprite.frame.origin.x) * CGFloat(index + 1))
            }
            scoreSprite.isOn = index < result?.score.rawValue ?? 0
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
}

fileprivate class ScoreSprite: UIView {
    var isOn: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: UIView
    public override func tintColorDidChange() {
        super.tintColorDidChange()
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerCurve = .continuous
        layer.cornerRadius = min(bounds.size.width, bounds.size.height) * 0.25
        backgroundColor = isOn ? tintColor : .systemGray5
    }
}
#endif
