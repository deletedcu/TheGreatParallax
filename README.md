## Parallax Scrolling and Stretchy header using UICollectionView and UICollectionViewCell in Swift
<p align="center">
 <img width="100px" src="https://res.cloudinary.com/anuraghazra/image/upload/v1594908242/logo_ccswme.svg" align="center" alt="GitHub Readme Stats" />
 <h2 align="center">GitHub Readme Stats</h2>
 <p align="center">Get dynamically generated GitHub stats on your readmes!</p>
</p>
<p align="center">
  <img src="https://img.shields.io/badge/Supported%20by-Xcode%20Power%20User%20%E2%86%92-gray.svg?colorA=655BE1&colorB=4F44D6&style=for-the-badge"/>
</p>

![burns](parallax.gif)
<img src="parallax.gif"/>

[Parallax scrolling](https://en.wikipedia.org/wiki/Parallax_scrolling) is a big UI design trend these days. It is a technique 
where background images move by the camera slower than foreground images, creating an illusion of depth in a 2D scene and 
adding to the immersion.

In this example we are using [UICollectionView](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UICollectionView_class/index.html) which is subclass of a [UIScrollView](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIScrollView_Class/index.html) and two images per CollectionView cell [UICollectionViewCell](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UICollectionViewCell_class/index.html). Each image
is contained inside an [UIImageView](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIImageView_Class/index.html) within the cell:

1. Background image which we are going to use for the parallax scrolling effect. The image here can be an image of some scenery
2. Foreground alpha image which remains static on top of the background image. The foreground can be a transparent image with some text 

```
    

    ...
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
```

The parallax scrolling is achieved by overriding `UIScrollView` delegate method `scrollViewDidScroll` where we change
the `Y` axis offset of the background image view in relation to the parent cell:

```
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset + self.offsetStep < scrollView.contentOffset.y) {
            self.lastContentOffset = scrollView.contentOffset.y
            applyParallax()
        }
        else if (self.lastContentOffset - self.offsetStep > scrollView.contentOffset.y) {
            self.lastContentOffset = scrollView.contentOffset.y
            applyParallax()
        }
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
```
We are using delegate `collectionView:layout:sizeForItemAtIndexPath:` from [UICollectionViewDelegateFlowLayout](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UICollectionViewDelegateFlowLayout_protocol/index.html) to control the height of cells in our `UICollectionView`. In other words, 
how many cells should be visible to user at once:

```
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch Section(section) {
        case .original:
            return Constants.imageHeaderSize
        default:
            return CGSize.zero
        }
    }
```

StretchyHeaderView is an implementation of the stretchy header paradigm as seen on many apps, like Twitter, Spotify or airbnb. It's designed in order to accomplish the following requirements:

- Compatibility with `UITableView` and `UICollectionView`
- Data source and delegate independency: can be added to an existing view controller withouth interfering with your existing `delegate` or `dataSource`
- Provide support for frame layout, auto layout and Interface Builder `.xib` files
- No need to subclass a custom view controller or to use a custom `UICollectionViewLayout`
- Simple usage: just implement your own subclass and add it to your `UIScrollView` subclass
- Two expansion modes: the header view can grow only when the top of the scroll view is reached, or as soon as the user scrolls down.

If you are using this library in your project, I would be more than glad to [know about it!](mailto:gskbyte@gmail.com)

## Usage

To add a stretchy header to your table or collection view, you just have to do this:

```
    collectionView.register(UINib(nibName: "\(FeedOriginalHeaderReusableView.self)", bundle: Bundle.main),
        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FeedOriginalHeaderReusableView.reuseIdentifier)
    ...
    collectionView.collectionViewLayout = StretchyHeaderCollectionViewFlowLayout()
```

## 🌱 Technologies and Frameworks
<p>
    <!-- Swift -->
    <img src="https://img.shields.io/badge/Swift-fa7343?flat=plastic&logo=swift&logoColor=white" height="32" alt="Swift" />
    &nbsp;
    <!-- CocoaPods -->
    <img src="https://img.shields.io/badge/CocoaPods-ee3322?flat=plastic&logo=cocoapods&logoColor=white" height="32" alt="CocoaPods" />
    &nbsp;
    <!-- Xcode -->
    <img src="https://img.shields.io/badge/Xcode-147efb?flat=plastic&logo=xcode&logoColor=white" height="32" alt="Xcode" />
    &nbsp;
</p>
