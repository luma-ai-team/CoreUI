//
//  File.swift
//  
//
//  Created by Roi Mulia on 30/10/2022.
//

import UIKit

open class AdaptiveCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    public enum CellSizeRule {
        case adaptive
        case fixed(CGSize)
    }

    public let cellSizeBehaviour:  CellSizeRule
    let preferredSpacing: CGFloat

    public init(
        cellSizeBehaviour: CellSizeRule = .adaptive,
        spacing: CGFloat = 8,
        sectionInset: UIEdgeInsets = .init(top: 0, left: 20, bottom: 0, right: 20)
    ) {
        self.cellSizeBehaviour = cellSizeBehaviour
        self.preferredSpacing = spacing
        super.init()
        scrollDirection = .horizontal
        self.sectionInset = sectionInset
    }
        
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
