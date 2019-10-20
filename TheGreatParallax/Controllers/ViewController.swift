import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    private enum Section: Int, CaseIterable {
        case original = 0
        case header = 1
        case videos = 2
        
        init(at indexPath: IndexPath) {
            self.init(rawValue: indexPath.section)!
        }
        
        init(_ section: Int) {
            self.init(rawValue: section)!
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private weak var originalHeaderReusableView: FeedOriginalHeaderReusableView?
    
    private var sampleVideos: [Video] {
        return [
            Video(title: "One", placeholderImage: UIImage(named: "1")!),
            Video(title: "Two", placeholderImage: UIImage(named: "2")!),
            Video(title: "Three", placeholderImage: UIImage(named: "3")!),
            Video(title: "Four", placeholderImage: UIImage(named: "4")!),
            Video(title: "Five", placeholderImage: UIImage(named: "5")!),
            Video(title: "Six", placeholderImage: UIImage(named: "6")!),
            Video(title: "Seven", placeholderImage: UIImage(named: "7")!),
            Video(title: "Eight", placeholderImage: UIImage(named: "8")!),
            Video(title: "Nine", placeholderImage: UIImage(named: "9")!),
            Video(title: "Ten", placeholderImage: UIImage(named: "10")!)
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.decelerationRate = UIScrollView.DecelerationRate.normal
        
        collectionView.register(UINib(nibName: "\(FeedOriginalHeaderReusableView.self)", bundle: Bundle.main),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FeedOriginalHeaderReusableView.reuseIdentifier)
        collectionView.register(UINib(nibName: "\(FeedHeaderCollectionViewCell.self)", bundle: Bundle.main), forCellWithReuseIdentifier: FeedHeaderCollectionViewCell.reuseIdentifier)
        collectionView.register(UINib(nibName: "\(VideoCollectionViewCell.self)", bundle: Bundle.main), forCellWithReuseIdentifier: VideoCollectionViewCell.reuseIdentifier)
        
        collectionView.collectionViewLayout = StretchyHeaderCollectionViewFlowLayout()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        applyParallax()
    }
    
    func applyParallax() {
        let offsetX = (self.view.frame.width - self.view.frame.origin.x) / (2 * self.view.frame.width)
        for row in collectionView.visibleCells {
            if let cell = row as? ParallaxCollectionViewCell {
                let offsetY = (cell.center.y + cell.bounds.height * 0.5 - collectionView.contentOffset.y) / (collectionView.bounds.height + cell.bounds.height)
                cell.parallaxOffset = CGPoint(x: offsetX, y: offsetY)
            }
        }
    }
    
    private func setSizeFotItemInCollectionView(itemsPerRow: CGFloat, paddingSpace: CGFloat, heightPerItem: CGFloat) -> CGSize {
        let itemsPerRow = itemsPerRow
        let paddingSpace = paddingSpace
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = heightPerItem
        return CGSize(width: widthPerItem, height: heightPerItem)
    }

}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(section) {
        case .original:
            return 0
        case .header:
            return 1
        case .videos:
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch Section(at: indexPath) {
        case .original:
            fatalError("No items should be in the original section.")
        case .header:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedHeaderCollectionViewCell.reuseIdentifier, for: indexPath) as! FeedHeaderCollectionViewCell
            return cell
        case .videos:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.reuseIdentifier, for: indexPath) as! VideoCollectionViewCell
            let video = sampleVideos[indexPath.row]
            cell.configure(video: video)
            
            let offsetX = (self.view.frame.width - self.view.frame.origin.x) / (2 * self.view.frame.width)
            let offsetY = (cell.center.y + cell.bounds.height * 0.5 - collectionView.contentOffset.y) / (collectionView.bounds.height + cell.bounds.height)
            cell.parallaxOffset = CGPoint(x: offsetX, y: offsetY)
            return cell
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("\(type(of: self)) only has a custom original header.")
        }
                
        switch Section(at: indexPath) {
        case .original:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FeedOriginalHeaderReusableView.reuseIdentifier, for: indexPath) as! FeedOriginalHeaderReusableView
            originalHeaderReusableView = header
            return header
        default:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FeedOriginalHeaderReusableView.reuseIdentifier, for: indexPath)
            header.frame.size.height = 0.0
            header.frame.size.width = 0.0
            return header
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = Section(at: indexPath)
        
        switch section {
        case .original:
            // There should be no items in the original section.
            return .zero
        case .header:
            return setSizeFotItemInCollectionView(itemsPerRow: 1.0, paddingSpace: 0.0, heightPerItem: Constants.defaultSectionHeight)
        case .videos:
            return setSizeFotItemInCollectionView(itemsPerRow: 1.0, paddingSpace: 0.0, heightPerItem: Constants.defaultCellHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 4.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch Section(section) {
        case .original:
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.width * Constants.headerImageHeight / Constants.headerImageWidth - Constants.statusbarHeight)
        default:
            return CGSize.zero
        }
    }
}
