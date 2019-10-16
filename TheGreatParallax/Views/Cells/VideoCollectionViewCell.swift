import UIKit

final class VideoCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "\(VideoCollectionViewCell.self)"

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var videoImageView: UIImageView!
    
    func configure(video: Video) {
        titleLabel.text = video.title
        //videoImageView.image = video.placeholderImage
    }
}
