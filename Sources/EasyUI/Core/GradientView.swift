//
//  GradientView.swift
//  TestKeyboardKeyboard
//
//  Created by Anton K on 25.03.2020.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import UIKit

open class GradientView: UIView {
    
    public init(gradient: Gradient = Gradient(direction: .horizontal, colors: [.red, .blue])) {
        self.gradient = gradient
        super.init(frame: .zero)
    }
    
    required public init?(coder: NSCoder) {
        self.gradient = .init(direction: .horizontal, colors: [.red, .blue])
        super.init(coder: coder)
    }
    
    
   public var isReversed: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    public var locations: [NSNumber]?  {
        get {
            gradient.locations
        }
        set {
            gradient.locations = newValue
        }
    }
    
    public var gradient: Gradient {
        didSet {
            setNeedsLayout()
        }
    }
 
    override open class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        guard let gradientLayer = layer as? CAGradientLayer else {
            return
        }
        
        var preparedColors = (isReversed ? gradient.colors.reversed() : gradient.colors)
        if preparedColors.count == 1, let color = preparedColors.first {
            preparedColors.append(color)
        }
        
        gradientLayer.colors = preparedColors.map(\.cgColor)
        gradientLayer.startPoint = gradient.direction.points.start
        gradientLayer.endPoint = gradient.direction.points.end
        gradientLayer.locations = locations
    }
}

