
import Foundation
import UIKit

import UIKit


// MARK: - ShimmerButton Class Definition
open class ShimmerButton: GradientButton {
    
    // MARK: - Private Properties
    private let gradientLayer = CAGradientLayer()
    
    // MARK: - Public Properties
    
    /// The style of the bounce animation.
    public var bounceStyle: BounceAnimationStyle = .medium {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    /// The color used for the shimmer effect.
    public var shimmerColor: UIColor = .white {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonSetup()
    }
    
    // MARK: - Private Methods
    
    /// Common setup for both frame and coder initializers
    private func commonSetup() {
        self.backgroundGradeintView.layer.addSublayer(gradientLayer)
        addBounce()
    }
    
    // MARK: - Lifecycle Methods
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
        applyDiagonalShimmer()
        applyBounceAnimation(style: bounceStyle)
    }
    
    // MARK: - Shimmer Effect
    
    /// Applies a diagonal shimmer effect to the button.
    private func applyDiagonalShimmer() {
        gradientLayer.removeAllAnimations()
        let color = shimmerColor
        
        // Define gradient colors
        gradientLayer.colors = [
            color.withAlphaComponent(0).cgColor,
            color.withAlphaComponent(0).cgColor,
            color.withAlphaComponent(0.1).cgColor,
            color.withAlphaComponent(0.6).cgColor,
            color.withAlphaComponent(0.1).cgColor,
            color.withAlphaComponent(0).cgColor,
            color.withAlphaComponent(0).cgColor
        ]
        
        // Apply diagonal appearance
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.15)
        
      
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -self.bounds.width
        animation.toValue = self.bounds.width
        animation.duration = 2.5
        
        // Set animation properties
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        
        gradientLayer.add(animation, forKey: "shimmerAnimation")
    }
}
