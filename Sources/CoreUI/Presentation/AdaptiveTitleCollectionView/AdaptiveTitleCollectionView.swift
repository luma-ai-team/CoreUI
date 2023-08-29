//
//  MusicToolsNavigationBar.swift
//  Music
//
//  Created by Roi Mulia on 14/03/2022.
//

import UIKit

public protocol AdaptiveCollectionViewItem: Equatable {
    var title: String { get }
}

public protocol AdaptiveTitleCollectionViewCell: UICollectionViewCell {
    associatedtype Item: AdaptiveCollectionViewItem
    static func create() -> any AdaptiveTitleCollectionViewCell
    static func register(in collectionView: UICollectionView, withIdentifier identifier: String)
    func configureCell(with item: Item, isSelected: Bool)
}

open class AdaptiveTitleCollectionView<T: HighlightedCollectionViewCell & AdaptiveTitleCollectionViewCell>: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    open override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    open override var contentSize: CGSize {
        didSet {
            guard contentSize.width > oldValue.width else {
                return
            }
            DispatchQueue.main.async {
                self.setNeedsLayout()
                self.layoutIfNeeded()
                self.invalidateIntrinsicContentSize()
            }
        }
    }
    
    public var items: [T.Item] = [] {
        didSet {
            reloadData()
        }
    }
    
    public var didTap: ((_ indexPath: IndexPath, _ item: T.Item) -> Void)?
    public var cellForItemOverride: ((_ cell: T, _ item: T.Item, Bool) -> Void)?
    
    public var selectedIndexPath: IndexPath = .init(item: 0, section: 0) {
        didSet {
            guard oldValue != selectedIndexPath else {
                return
            }   
           reloadData()
        }
    }

    public var automaticallyAdjustsCellSpacing: Bool = true
    public lazy var minimalCellSpacing: CGFloat = 0.5 * layout.preferredSpacing
    public lazy var maximalCellSpacing: CGFloat = 2.0 * layout.preferredSpacing

    private let layout: AdaptiveCollectionViewFlowLayout
    private var previousWidth: CGFloat = 0.0
    private lazy var autocalculatedCellSpacing: CGFloat = layout.preferredSpacing
    private let staticCell = T.create() as! T

    public init(items: [T.Item], layout: AdaptiveCollectionViewFlowLayout) {
        self.items = items
        self.layout = layout
        super.init(frame: .zero, collectionViewLayout: layout)
        T.register(in: self, withIdentifier: "\(T.self)")
        delegate = self
        dataSource = self
        contentInset = .zero
        showsHorizontalScrollIndicator = false
        delaysContentTouches = false
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        if previousWidth != bounds.width {
            recalculateCellSpacingIfNeeded()
        }
        previousWidth = bounds.width
    }

    private func recalculateCellSpacingIfNeeded() {
        guard automaticallyAdjustsCellSpacing,
              bounds.width > 0 else {
            return
        }

        var targetSpacing: CGFloat = layout.preferredSpacing
        var itemIter: CGFloat = 0.0

    sectionLoop:
        for section in stride(from: 0, to: numberOfSections, by: 1) {
            let itemCount = numberOfItems(inSection: section)
            for item in stride(from: 0, to: itemCount, by: 1) {
                guard let rect = layoutAttributesForItem(at: .init(item: item, section: section))?.frame else {
                    continue
                }

                let isLastItem = (item + 1) == itemCount
                let delta: CGFloat = 0.5 * rect.width
                let triggerRange = (bounds.width - delta)...(bounds.width + delta)
                if triggerRange.contains(rect.maxX),
                   isLastItem == false {
                    let spacingDelta = abs(rect.maxX - bounds.width - delta) / itemIter
                    targetSpacing = autocalculatedCellSpacing + spacingDelta
                    if targetSpacing < maximalCellSpacing {
                        break sectionLoop
                    }
                }

                if triggerRange.contains(rect.minX) {
                    let spacingDelta = abs(rect.minX - bounds.width + delta) / itemIter
                    targetSpacing = max(autocalculatedCellSpacing - spacingDelta, minimalCellSpacing)
                    break sectionLoop
                }
                itemIter += 1.0
            }
        }

        if targetSpacing != autocalculatedCellSpacing {
            autocalculatedCellSpacing = targetSpacing
            reloadData()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(T.self)", for: indexPath) as? T else {
            fatalError()
        }
        
        let item = items[indexPath.item]
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        cell.configureCell(with: item, isSelected: indexPath == selectedIndexPath)
        cellForItemOverride?(cell, item, indexPath == selectedIndexPath)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        didTap?(indexPath, item)
        selectedIndexPath = indexPath
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return autocalculatedCellSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return autocalculatedCellSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let adaptiveLayout = collectionViewLayout as? AdaptiveCollectionViewFlowLayout else {
            return .init(width: 30, height: 30)
        }

        switch adaptiveLayout.cellSizeBehaviour {
        case .adaptive:
            let item = items[indexPath.item]
            let isSelected = indexPath == selectedIndexPath
            staticCell.configureCell(with: item, isSelected: isSelected)
            cellForItemOverride?(staticCell, item, isSelected)
            let size = staticCell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            return size
        case .fixed(let fixedSize):
            return fixedSize
        }
    }
}
