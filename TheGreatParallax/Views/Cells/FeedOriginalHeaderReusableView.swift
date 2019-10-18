import UIKit

final class FeedOriginalHeaderReusableView: ParallaxHeaderView {
    
    static let reuseIdentifier = "\(FeedOriginalHeaderReusableView.self)"
    
    @IBOutlet weak var textView: UIView!
}
