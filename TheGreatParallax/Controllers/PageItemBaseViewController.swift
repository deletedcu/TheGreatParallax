//
//  PageItemBaseViewController.swift
//  TheGreatParallax
//
//  Created by King on 2019/10/17.
//  Copyright © 2019 Larry Natalicio. All rights reserved.
//

import UIKit

protocol PageItemBaseViewControllerDelegate: NSObjectProtocol {
    func pageItemBaseViewController(_ viewController: PageItemBaseViewController, scrollViewDidScroll scrollView: UIScrollView)
    func pageItemBaseViewController(_ viewController: PageItemBaseViewController, scrollViewWillBeginDragging scrollView: UIScrollView)
    func pageItemBaseViewController(_ viewController: PageItemBaseViewController, scrollViewDidEndDragging scrollView: UIScrollView, willDecelerate decelerate: Bool)
    func pageItemBaseViewController(_ viewController: PageItemBaseViewController, scrollViewWillEndDragging scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
}

class PageItemBaseViewController: UIViewController {
    
    weak var delegate: PageItemBaseViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension PageItemBaseViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.pageItemBaseViewController(self, scrollViewDidScroll: scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.pageItemBaseViewController(self, scrollViewWillBeginDragging: scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.pageItemBaseViewController(self, scrollViewDidEndDragging: scrollView, willDecelerate: decelerate)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.pageItemBaseViewController(self, scrollViewWillEndDragging: scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
}
