import UIKit

final class FeedOriginalHeaderReusableView: UICollectionReusableView {
    
    static let reuseIdentifier = "\(FeedOriginalHeaderReusableView.self)"
    
    @IBOutlet weak var textView: UIView!
}
