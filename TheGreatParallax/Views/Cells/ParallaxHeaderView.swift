//
//  ParallaxHeaderView.swift
//  TheGreatParallax
//
//  Created by King on 2019/10/18.
//  Copyright © 2019 Larry Natalicio. All rights reserved.
//
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

protocol ParallaxHeaderViewDelegate: NSObjectProtocol {
    func ParallaxHeaderViewPositionChanged(cell: ParallaxHeaderView)
}

class ParallaxHeaderView: UICollectionReusableView {
    
    weak var delegate: ParallaxHeaderViewDelegate?
    
    // unit position
    var parallaxOffset: CGPoint? {
        didSet {
            applyParallax()
        }
    }
    
    // parallax factor that represents the amount of parallax in pixel (0 - 100)
    var parallaxFactor: CGFloat! = 30
    
    // Parallax effect applied on containerView
    @IBOutlet weak var parallaxView: UIView!
    @IBOutlet weak var parallaxBottomConstraint: NSLayoutConstraint!
    
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
        
        parallaxInitialEdge = UIEdgeInsets(top: 0,
                                           left: 0,
                                           bottom: parallaxBottomConstraint.constant,
                                           right: 0)
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
        
        let pixelOffsetY = offset.y * (100 - parallaxFactor) / 100
        
        self.parallaxBottomConstraint.constant = parallaxInitialEdge.bottom - pixelOffsetY
        
        self.parallaxView.superview?.layoutIfNeeded()
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        delegate?.ParallaxHeaderViewPositionChanged(cell: self)
    }
}
