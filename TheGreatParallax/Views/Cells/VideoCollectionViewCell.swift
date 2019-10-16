import UIKit

class VideoCollectionViewCell: ParallaxCollectionViewCell {
    
    static let reuseIdentifier = "\(VideoCollectionViewCell.self)"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var videoImageView: UIImageView!
    
    func configure(video: Video) {
        titleLabel.text = video.title
        videoImageView.image = video.placeholderImage
    }
}
