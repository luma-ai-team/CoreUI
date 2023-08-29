//
//  File.swift
//  
//
//  Created by Roi Mulia on 24/03/2022.
//

import UIKit


open class GradientBorderView: UIView {
    
    public var borderWidth: CGFloat = 4 {
        didSet {
            maskingView.layer.borderWidth = borderWidth
        }
    }
    
    public var cornerRadius: CGFloat = 10 {
        didSet {
            maskingView.roundCorners(to: .custom(cornerRadius))
        }
    }
    
    public let gradientView = GradientView()
    
    private let maskingView = UIView()
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        addSubview(gradientView)
        maskingView.layer.borderWidth = borderWidth
        maskingView.roundCorners(to: .custom(cornerRadius))
        maskingView.backgroundColor = .clear
        gradientView.bindMarginsToSuperview()
        gradientView.mask = maskingView
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        UIView.performWithoutAnimation {
            maskingView.frame = bounds
        }
    }
    
}
