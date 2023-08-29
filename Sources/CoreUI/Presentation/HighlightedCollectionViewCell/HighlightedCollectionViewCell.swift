//
//  File.swift
//  
//
//  Created by Roi Mulia on 14/04/2022.
//

import UIKit

open class HighlightedCollectionViewCell: UICollectionViewCell {
    
    open override var isHighlighted: Bool {
        didSet {
            guard oldValue != isHighlighted else { return }
            let transform = isHighlighted ? CGAffineTransform(scaleX: 0.92, y: 0.92) : .identity
            let alpha: CGFloat = isHighlighted ? 0.42 : 1
            UIView.animate(withDuration: 0.12, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState]) {
                self.contentView.transform  = transform
                self.contentView.alpha = alpha
            }
        }
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        isHighlighted = false
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        contentView.bounds = bounds
        contentView.center = .init(x: bounds.midX, y: bounds.midY)
    }
}
