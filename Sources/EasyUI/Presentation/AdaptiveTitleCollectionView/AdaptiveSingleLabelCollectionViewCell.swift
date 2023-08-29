//
//  File.swift
//  
//
//  Created by Roi Mulia on 30/10/2022.
//

import UIKit
open class AdaptiveSingleLabelCollectionViewCell: HighlightedCollectionViewCell {
    
    public var titleLabel = UILabel()
    public var gradientView = GradientView(gradient: .init(direction: .horizontal, colors: [.red, .blue]))
    public var labelPadding: CGFloat = 5
    public var labelHeight: CGFloat = 30
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    open func commonInit() {
        contentView.addSubview(gradientView)
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: labelPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -labelPadding),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            titleLabel.heightAnchor.constraint(equalToConstant: labelHeight),
        ])
        gradientView.bindMarginsToSuperview()
    }
}
