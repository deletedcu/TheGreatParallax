///
///
///*** Wenjie original parallax cell ***///


///  Usage:
///  Say we parallax parallaxView:
///  A. Interface (Xib or Storyboard)
///      1. Put all items that you want to apply parallax effect in parallaxView
///      2. parallaxView can be placed anywhere under the cell
///      3. Set leading/traing/top/bottom constraint for parallaxView
///      4. Link IBOutlet for parallaxView : view itself, 4 constraints (leading, trailing, top, bottom)
///  B. Override parallaxFactor
///      - You can use adjust the amount of parallax with this
///  C. Set cell.parallaxOffset (CGPoint)
///  D. Set delegate as need

import UIKit

protocol ParallaxCollectionViewCellDelegate: NSObjectProtocol {
    func parallaxCollectionViewCellPositionChanged(cell: ParallaxCollectionViewCell)
}

final class ParallaxCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    
    // Parallax effect applied on this container view.
    @IBOutlet weak var parallaxView: UIView!
    @IBOutlet weak var parallaxViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var parallaxViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var parallaxViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var parallaxViewRightConstraint: NSLayoutConstraint!
    
    weak var delegate: ParallaxCollectionViewCellDelegate?
    private var observing = false
    
    /// Unit position
    var parallaxOffset: CGPoint? {
        didSet {
            applyParallax()
        }
    }
    
    /// Parallax factor that represents the amount of parallax in pixel
    var parallaxFactor: CGPoint {
        return CGPoint(x: 70, y: 70)
    }
    
    /// Inital values for 4 constraints
    private var parallaxInitialEdge: UIEdgeInsets!
    
    // MARK: - View Life Cycle
    
    deinit {
        if observing {
            observing = false
            self.removeObserver(self, forKeyPath: "center")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        parallaxViewRightConstraint.constant -= parallaxFactor.x * 2
        parallaxViewBottomConstraint.constant -= parallaxFactor.y * 2
        
        parallaxInitialEdge = UIEdgeInsets(top: parallaxViewTopConstraint.constant,
                                           left: parallaxViewLeftConstraint.constant,
                                           bottom: parallaxViewBottomConstraint.constant,
                                           right: parallaxViewRightConstraint.constant)
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if self.superview != nil {
            if !observing {
                observing = true
                self.addObserver(self, forKeyPath: "center", options: .new, context: nil)
            }
        } else {
            if observing {
                observing = false
                self.removeObserver(self, forKeyPath: "center")
            }
        }
    }
    
    // MARK: - Convenience Methods
    
    func applyParallax() {
        guard let offset = parallaxOffset else {
            return
        }
        
        let pixelOffsetX = (1 - max(0, min(1, offset.x))) * 2 * parallaxFactor.x
        let pixelOffsetY = max(0, min(1, offset.y)) * 2 * parallaxFactor.y
        
        parallaxViewLeftConstraint.constant = parallaxInitialEdge.left - pixelOffsetX
        parallaxViewRightConstraint.constant = parallaxInitialEdge.right + pixelOffsetX
        
        parallaxViewTopConstraint.constant = parallaxInitialEdge.top - pixelOffsetY
        parallaxViewBottomConstraint.constant = parallaxInitialEdge.bottom + pixelOffsetY
        
        parallaxView.superview?.layoutIfNeeded()
    }
    
    // MARK: - Key-Value Observing Method
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(UICollectionView.center) {
            delegate?.parallaxCollectionViewCellPositionChanged(cell: self)
        }
    }
}

