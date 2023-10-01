//
//  RoundedFontLabel.swift
//  TestProject
//
//  Created by Roi Mulia on 21/09/2020.
//  Copyright © 2020 Roi Mulia. All rights reserved.
//

import UIKit


open class OutterGradientButton: GradientButton {

    public var bounceStyle: BounceAnimationStyle = .heavy
    
    public var shouldBounceSuperview: Bool = false
    
    public var outlineView = PiercedView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        
    }
    
    private func setup() {
        addSubview(outlineView)
        cornerRadiusStyle = .custom(0)
        addBounce()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        outlineView.frame = bounds
        mask = outlineView
    }
    
    
    public func applyBounce() {
        applyBounceAnimation(style: bounceStyle)
    }
    
  
}

// MARK: - PiercedView

open class PiercedView: UIView {
    
    var innerView = UIView()
    public var borderWidth: CGFloat = 3
    public var gapWidth: CGFloat = 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(innerView)
        innerView.backgroundColor = .white
        layer.borderColor = UIColor.white.withAlphaComponent(0.6).cgColor
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderWidth = borderWidth
        
        let inset = borderWidth + gapWidth
        let innerViewBounds = bounds.insetBy(dx: inset, dy: inset)
        innerView.frame = innerViewBounds
        
        for v in [self, innerView] {
            v.clipsToBounds = true
            v.layer.roundCorners(to: .rounded)
        }
    }
}
