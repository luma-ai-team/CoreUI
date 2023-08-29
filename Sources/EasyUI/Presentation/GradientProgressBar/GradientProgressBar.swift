//
//  GradientProgress.swift
//  GradientProgress
//
//  Created by Dmitry Smetankin on 09.09.17.
//  Copyright © 2017 GradientProgress. All rights reserved.
//

import UIKit

public class GradientProgressBar: UIView {
    
    public enum GradientProgressBarProgressAnimation {
        case none
        case animated(duration: TimeInterval)
    }
    
    // MARK: - Properties
    private var progress: CGFloat = 0 
    
    private var gradientView = GradientView()
    
    public var progressGradient: Gradient {
        get {
            return gradientView.gradient
        }
        set {
            gradientView.gradient = newValue
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
  
    // MARK: - init methods
    
    public init(colorScheme: ColorScheme) {
        super.init(frame : .zero)
        backgroundColor = colorScheme.notActive
        progressGradient = colorScheme.gradient
        setup()
    }
    
    public init() {
        super.init(frame: .zero)
        setup()
    }
    
    public init (progressGradient: Gradient) {
        super.init(frame : .zero)
        self.progressGradient = progressGradient
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Private methods
    
    private func setup() {
        addSubview(gradientView)
    }
    
    // MARK: Layout
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        clipsToBounds = true
        layer.masksToBounds = true
        roundCorners(to: .rounded)
        
        let newWidth = bounds.width * progress
        gradientView.frame.size.width = newWidth
        gradientView.frame.size.height = bounds.height
        gradientView.frame.origin.x = 0
        gradientView.frame.origin.y = 0
        
        UIView.performWithoutAnimation {
            gradientView.roundCorners(to: .rounded)
        }
    }
    
    
    public func setProgress(progress: CGFloat, animation: GradientProgressBarProgressAnimation) {
        self.progress = progress
        switch animation {
        case .none:
            setNeedsLayout()
            layoutIfNeeded()
        case .animated(duration: let duration):
            UIView.animate(withDuration: duration) {
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        }
    }
  

}
