import UIKit

final class StretchyHeaderCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        // 1. Extract the layout attributes
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        
        // 2. Loop through each attribute and identify which one you want to modify
        layoutAttributes?.forEach { attributes in
            
            // 3. Check for Header and (for additional check you can use indexPath whether we want stretchy on list header)
            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader {
                guard let collectionView = collectionView else {
                    return
                }
                let contentOffsetY = collectionView.contentOffset.y
                
                if contentOffsetY > attributes.frame.height {
                    return
                }
                
                let width = collectionView.frame.width
                // 4. as contentOffsetY is -ve, the height will increase based on contentOffsetY
                let height = attributes.frame.height - contentOffsetY
                attributes.frame = CGRect(x: 0, y: contentOffsetY, width: width, height: height)
            }
        }
        
        // 5. return
        return layoutAttributes
    }
    
    // 6. invalidate the layout for new bounds
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
