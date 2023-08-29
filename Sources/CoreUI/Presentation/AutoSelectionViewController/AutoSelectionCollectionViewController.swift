//
//  Created by Roi Mulia on 12/18/18.
//  Copyright © 2018 Paul Ulric. All rights reserved.
//

import UIKit


public protocol AutoSelectItem: Equatable {
    var title: String { get }
}

public protocol AutoSelectCell: AnyObject {
    associatedtype Item: AutoSelectItem
    
    static func instantiate() -> Self
    static func register(in collectionView: UICollectionView, withIdentifier identifier: String)
    func configureCell(with item: Item, isSelected: Bool)
}

public class AutoSelectionCollectionViewController<T: UICollectionViewCell & AutoSelectCell>: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    override public var prefersStatusBarHidden: Bool {
        return true
    }

    public var sections: [[T.Item]] {
        didSet {
            collectionView.reloadData()
            updateItemCount()
        }
    }

    public var layout: AutoSelectionFlowLayout {
        didSet {
            collectionView.collectionViewLayout = layout
            collectionView.reloadData()
        }
    }

    public var sectionSpacing: CGFloat = 0.0

    public var didSelect: ((_ item: T.Item) -> Void)?
    public var didTap: ((_ item: T.Item) -> Void)?
    public var didFinishSelection: ((_ item: T.Item) -> Void)?
    public var didChangeSection: ((_ section: Int) -> Void)?
    public var didScroll: ((_ offset: CGFloat) -> Void)?
    public var cellConfigurationBlock: ((_ cell: T, _ item: T.Item) -> Void)?
    
    public var offset: CGFloat {
        get {
            var nextCellFrame: CGRect = .zero
            var previousIndexPath: IndexPath = .init()
            var baseOffset: CGFloat = 0.0
            let lastOffset = CGFloat(itemCount - 1)
            
            let position = collectionView.contentOffset.x + view.bounds.width / 2.0
            for index in stride(from: 1, to: itemCount, by: 1) {
                let indexPath = IndexPath(row: index, section: 0)
                guard let cellFrame = collectionViewLayout.layoutAttributesForItem(at: indexPath)?.frame else {
                    continue
                }
                
                if cellFrame.midX >= position {
                    nextCellFrame = cellFrame
                    previousIndexPath = IndexPath(row: index - 1, section: 0)
                    break
                }
                
                baseOffset += 1.0
            }
            
            guard nextCellFrame.isEmpty == false else {
                return lastOffset
            }
            
            guard let previousCellFrame = collectionViewLayout.layoutAttributesForItem(at: previousIndexPath)?.frame else {
                return 0.0
            }
            
            let offset = baseOffset + 1.0 - (nextCellFrame.midX - position) / (nextCellFrame.midX - previousCellFrame.midX)
            return offset.clamped(min: 0.0, max: lastOffset)
        }
        set {
            let previousItem = Int(floor(newValue)).clamped(min: 0, max: itemCount - 1)
            let nextItem = Int(ceil(newValue)).clamped(min: 0, max: itemCount - 1)
            let delta = newValue - floor(newValue)
            
            let previousIndexPath = IndexPath(item: previousItem, section: 0)
            let nextIndexPath = IndexPath(item: nextItem, section: 0)
            guard let previousCellFrame = collectionViewLayout.layoutAttributesForItem(at: previousIndexPath)?.frame,
                  let nextCellFrame = collectionViewLayout.layoutAttributesForItem(at: nextIndexPath)?.frame else {
                return
            }
            
            let scrollOffset = previousCellFrame.midX + delta * (nextCellFrame.midX - previousCellFrame.midX)
            collectionView.setContentOffset(.init(x: scrollOffset - 0.5 * view.bounds.width, y: 0.0), animated: false)
        }
    }

    public var selectedIndexPath : IndexPath {
        didSet {
            guard selectedIndexPath != oldValue, isViewLoaded else {
                return
            }
            
            if selectedIndexPath.section != oldValue.section {
                didChangeSection?(selectedIndexPath.section)
            }
            
            let selectedItem = sections[selectedIndexPath.section][selectedIndexPath.item]
            UIView.performWithoutAnimation {
                (collectionView.cellForItem(at: selectedIndexPath) as? T)?.configureCell(with: selectedItem, isSelected: true)
                let oldItem = sections[oldValue.section][oldValue.item]
                (collectionView.cellForItem(at: oldValue) as? T)?.configureCell(with: oldItem, isSelected: false)
            }
            
            Haptic.selection.generate()
            didSelect?(selectedItem)
        }
    }
    
    public var selectedItem: T.Item {
        return sections[selectedIndexPath.section][selectedIndexPath.item]
    }
    
    private lazy var sizeCell: T = T.fromNib()
    private var useCellSizeCache: Bool = true
    private lazy var cellSizeCache: [IndexPath: CGSize] = .init()
    
    
    private var needsDelayedScrolling : Bool = false
    
    private var itemCount: Int = 0
    
    // MARK: -
    
    public convenience init(dataSource: [[T.Item]],
                            sizeMode: AutoSelectionFlowLayout.SizeMode,
                            cellSpacing: CGFloat,
                            bottomInset: CGFloat = 0,
                            selectedIndexPath: IndexPath = .init(item: 0, section: 0),
                            useCellSizeCache: Bool = true) {
        self.init(collectionViewLayout: .init(mode: sizeMode, spacing: cellSpacing, bottomInset: bottomInset),
                  sections: dataSource,
                  selectedIndexPath: selectedIndexPath)
        self.useCellSizeCache = useCellSizeCache
    }
    
    public init(collectionViewLayout layout: AutoSelectionFlowLayout, sections: [[T.Item]], selectedIndexPath: IndexPath) {
        self.sections = sections
        self.selectedIndexPath = selectedIndexPath
        self.layout = layout
        super.init(collectionViewLayout: layout)
        updateItemCount()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.isPrefetchingEnabled = false
        
        T.register(in: collectionView, withIdentifier: "\(T.self)")
        
        view.backgroundColor = .clear
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.clipsToBounds = false
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        needsDelayedScrolling = true
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if needsDelayedScrolling && collectionView.contentSize.width > 0 {
            needsDelayedScrolling = false
            DispatchQueue.main.async {
                self.collectionView?.scrollToItem(at: self.selectedIndexPath, at: .centeredHorizontally, animated: false)
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    override public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    override public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    override public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(T.self)", for: indexPath) as? T else {
            return .init()
        }
        
        let item = sections[indexPath.section][indexPath.item]
        cell.configureCell(with: item, isSelected: indexPath == selectedIndexPath)
        cellConfigurationBlock?(cell, item)
        return cell
    }
    
    override public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        let item = sections[indexPath.section][indexPath.item]
        didTap?(item)
        didFinishSelection?(item)
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        if useCellSizeCache, let cellSize = cellSizeCache[indexPath] {
            return cellSize
        }
        
        switch layout.sizeMode {
        case .fixed(let size):
            return size
        case .automatic:
            let item = sections[indexPath.section][indexPath.row]
            sizeCell.configureCell(with: item, isSelected: true)
            sizeCell.setNeedsLayout()
            sizeCell.layoutIfNeeded()
            
            let size = sizeCell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            if useCellSizeCache {
                cellSizeCache[indexPath] = size
            }
            return size
        }
    }
    
    // MARK: - Scroll view data source

    override public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard decelerate == false else {
            return
        }

        let item = sections[selectedIndexPath.section][selectedIndexPath.item]
        didFinishSelection?(item)
    }

    override public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let item = sections[selectedIndexPath.section][selectedIndexPath.item]
        didFinishSelection?(item)
    }
    
    override public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isDragging || scrollView.isDecelerating else {
            return
        }
        
        didScroll?(scrollView.contentOffset.x)

        let position = scrollView.contentOffset.x + collectionView.bounds.width / 2.0
        for indexPath in collectionView.indexPathsForVisibleItems {
            guard let cellFrame = layout.layoutAttributesForItem(at: indexPath)?.frame else {
                continue
            }

            guard cellFrame.contains(CGPoint(x: position, y: cellFrame.midY)) else {
                continue
            }

            selectedIndexPath = indexPath
            break
        }
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        let collectionSize = collectionView.bounds.size
        var itemSize = self.collectionView(collectionView,
                                           layout: collectionViewLayout,
                                           sizeForItemAt: .init(item: 0, section: section))
        itemSize.width = max(layout.itemSize.width, itemSize.width)
        itemSize.height = max(layout.itemSize.height, itemSize.height)
        let yInset = (collectionSize.height - itemSize.height) / 2
        var insets: UIEdgeInsets = .init(top: yInset, left: sectionSpacing, bottom: yInset + layout.bottomInset, right: 0.0)

        if section == 0 {
            insets.left = (collectionSize.width - itemSize.width) / 2
        }
        else {
            insets.left += layout.minimumInteritemSpacing
        }
        
        if (section == sections.count - 1) {
            let indexPath = IndexPath(item: collectionView.numberOfItems(inSection: section) - 1, section: section)
            let itemSize = self.collectionView(collectionView,
                                               layout: collectionViewLayout,
                                               sizeForItemAt: indexPath)
            insets.right = max(insets.left, (collectionSize.width - itemSize.width) / 2)
        }

        return insets
    }

    // MARK: - Private

    private func updateItemCount() {
        itemCount = sections.reduce(0) { (result: Int, items: [T.Item]) -> Int in
            return result + items.count
        }
    }
}
