//
//  Created by Paul Ulric on 23/06/2016.
//  Copyright © 2016 Paul Ulric. All rights reserved.
//

import UIKit
import AVFoundation

public class AutoSelectionFlowLayout: UICollectionViewFlowLayout {
    
    private struct LayoutState: Equatable {
        var size: CGSize
        var direction: UICollectionView.ScrollDirection
    }
    
    public enum SizeMode {
        case fixed(CGSize)
        case automatic
        
        var isAutomatic: Bool {
            switch self {
            case .automatic:
                return true
            default:
                return false
            }
        }
    }
    
    public let sizeMode: SizeMode
    public let bottomInset: CGFloat
    public let spacing: CGFloat
    var minimumCellWidth: CGFloat = 50.0

    private var state: LayoutState = .init(size: CGSize.zero, direction: .horizontal)
    
    public var cellSizeOverrides: [IndexPath: CGSize] = [:] {
        didSet {
            invalidateLayout()
        }
    }
    
    public var decelerationRate: CGFloat = UIScrollView.DecelerationRate.normal.rawValue
    public var canScrollMultiItems: Bool = true
    
    @IBInspectable open var sideItemScale: CGFloat = 0.8
    @IBInspectable open var sideItemAlpha: CGFloat = 1.0
    @IBInspectable open var sideItemShift: CGFloat = 0.0
    
    public init(mode: SizeMode, spacing: CGFloat, bottomInset: CGFloat = 0) {
        self.sizeMode = mode
        self.spacing = spacing
        self.bottomInset = bottomInset
        super.init()
        minimumInteritemSpacing = 0
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func prepare() {
        switch sizeMode {
        case .fixed(let size):
            itemSize = size
        case .automatic:
            break
        }
        
        super.prepare()
        
        scrollDirection = .horizontal
        collectionView?.contentInset.top = 0
        collectionView?.contentInset.bottom = bottomInset
        collectionView?.decelerationRate = UIScrollView.DecelerationRate(rawValue: decelerationRate)
        
        let currentState = LayoutState(size: collectionView?.bounds.size ?? .zero,
                                       direction: scrollDirection)
        if state != currentState {
            updateLayout()
            state = currentState
        }
    }
    
    private func updateLayout() {
        let side = itemSize.width
        let scaledItemOffset = (side - side * sideItemScale) / 2
        minimumLineSpacing = spacing - scaledItemOffset
        
        guard sizeMode.isAutomatic,
              let collectionView = collectionView else {
            return
        }
        
        let numberIfSections = collectionView.numberOfSections
        guard numberIfSections > 0 else {
            return
        }

        minimumCellWidth = 50
        for sectionIndex in stride(from: 0, to: numberIfSections, by: 1) {
            for itemIndex in stride(from: 0, to: collectionView.numberOfItems(inSection: sectionIndex), by: 1) {
                let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                guard let attributes = layoutAttributesForItem(at: indexPath) else {
                    continue
                }
                
                minimumCellWidth = max(min(minimumCellWidth, attributes.bounds.width), 50)
            }
        }
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
            let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes] else {
            return nil
        }
        
        return attributes.map { (attributes: UICollectionViewLayoutAttributes) in
            self.transformLayoutAttributes(attributes)
        }
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
            return nil
        }
        
        return transformLayoutAttributes(attributes)
    }
    
    private func transformLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = collectionView else {
            return attributes
        }
        
        let collectionCenter = collectionView.bounds.width / 2.0
        let offset = collectionView.contentOffset.x
        let normalizedCenter = attributes.center.x - offset
        let maxDistance = sizeMode.isAutomatic ? minimumCellWidth : (itemSize.width + minimumInteritemSpacing)
        let distance = min(abs(collectionCenter - normalizedCenter), maxDistance)
        let ratio = (maxDistance - distance) / maxDistance
        
        let alpha = ratio * (1.0 - sideItemAlpha) + sideItemAlpha
        let scale = ratio * (1.0 - sideItemScale) + sideItemScale
        let shift = (1.0 - ratio) * sideItemShift
        
        attributes.alpha = alpha
        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        attributes.zIndex = Int(alpha * 10)

        if let size = cellSizeOverrides[attributes.indexPath] {
            let oldWidth = attributes.bounds.size.width
            attributes.bounds.size = size
            attributes.center.x += 0.5 * (oldWidth - attributes.bounds.size.width)
        }

        attributes.center.y = collectionView.bounds.height / 2 + shift
        return attributes
    }
    
    override public func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                             withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard let collectionView = collectionView, collectionView.isPagingEnabled == false else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }

        let targetRect = CGRect(origin: .zero, size: collectionView.contentSize)
        guard let layoutAttributes = layoutAttributesForElements(in: targetRect) else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }

        let midSide = collectionView.bounds.size.width / 2.0
        let proposedContentOffsetCenterOrigin = proposedContentOffset.x + midSide
        
        let attributes = layoutAttributes.sorted { (lhs: UICollectionViewLayoutAttributes, rhs: UICollectionViewLayoutAttributes) in
            abs(lhs.center.x - proposedContentOffsetCenterOrigin) < abs(rhs.center.x - proposedContentOffsetCenterOrigin)
        }
        
        let closest = attributes.first ?? .init()
        return CGPoint(x: floor(closest.center.x - midSide), y: proposedContentOffset.y)
    }
}
