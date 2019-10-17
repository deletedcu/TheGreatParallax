//
//  ParallaxCollectionViewCell.swift
//  DemoScrollviewPaging
//
//  Created by user on 10/2/19.
//  Copyright © 2019 Developer. All rights reserved.
//
//  Usage:
//  Say we parallax parallaxViwe
//  A. Interface (Xib or Storyboard)
//      1. put all items that you want to apply parallax effect in parallaxView
//      2. parallaxView can be placed anywhere under the cell
//      3. set leading/traing/top/bottom constraint for parallaxView
//      4. link IBOutlet for parallaxView : view itself, 4 constraints(leading, trailing, top, bottom)
//  B. override parallaxFactor
//      you can use adjust the amount of parallax with this
//  C. set cell.parallaxOffset (CGPoint)
//  D. set delegate as need


import UIKit

protocol ParallaxCollectionViewCellDelegate: NSObjectProtocol {
    func parallaxCollectionViewCellPositionChanged(cell: ParallaxCollectionViewCell)
}

class ParallaxCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: ParallaxCollectionViewCellDelegate?
    
    // unit position
    var parallaxOffset: CGPoint? {
        didSet {
            applyParallax()
        }
    }
    
    // parallax factor that represents the amount of parallax in pixel
    var parallaxFactor: CGPoint {
        get {
            return CGPoint(x: 100, y: 100)
        }
    }
    
    // Parallax effect applied on containerView
    @IBOutlet weak var parallaxView: UIView!
    @IBOutlet weak var parallaxBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var parallaxTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var parallaxLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var parallaxRightConstraint: NSLayoutConstraint!
    
    // inital values for 4 constraints
    private var parallaxInitialEdge: UIEdgeInsets!
    private var observing = false
    
    deinit {
        if observing {
            observing = false
            self.removeObserver(self, forKeyPath: "center")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        parallaxRightConstraint.constant -= parallaxFactor.x * 2;
        parallaxBottomConstraint.constant -= parallaxFactor.y * 2;
        
        parallaxInitialEdge = UIEdgeInsets(top: parallaxTopConstraint.constant,
                                           left: parallaxLeftConstraint.constant,
                                           bottom: parallaxBottomConstraint.constant,
                                           right: parallaxRightConstraint.constant)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
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
    
    func applyParallax() {
        
        guard let offset = parallaxOffset else {
            return
        }
        
        let pixelOffsetX = (1 - max(0, min(1, offset.x))) * 2 * parallaxFactor.x
        let pixelOffsetY = max(0, min(1, offset.y)) * 2 * parallaxFactor.y
        
        self.parallaxLeftConstraint.constant = parallaxInitialEdge.left - pixelOffsetX
        self.parallaxRightConstraint.constant = parallaxInitialEdge.right + pixelOffsetX
        
        self.parallaxTopConstraint.constant = parallaxInitialEdge.top - pixelOffsetY
        self.parallaxBottomConstraint.constant = parallaxInitialEdge.bottom + pixelOffsetY
        
        self.parallaxView.superview?.layoutIfNeeded()
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        delegate?.parallaxCollectionViewCellPositionChanged(cell: self)
    }
}
