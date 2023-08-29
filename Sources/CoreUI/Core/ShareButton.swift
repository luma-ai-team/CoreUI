
import UIKit


// Represents a button specifically for sharing content
open class ShareButton: ExtendedHitTestButton {
    
    // UI Elements
    private let gradientBackgroundView = GradientView()
    private let shareIconImage = UIImage(named: "shareImage", in: .module, compatibleWith: nil)
    
    // Callback for tap action
    public var onTapAction: (() -> ())?
    
    // Initializers
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    public init(using colorScheme: ColorScheme) {
        super.init(frame: .zero)
        commonSetup()
        applyColorScheme(colorScheme)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonSetup()
    }
    
    // Common UI setup
    private func commonSetup() {
        hitTestPadding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        setImage(shareIconImage, for: .normal)
        
        setupGradientBackground()
        addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    // Gradient Background Setup
    private func setupGradientBackground() {
        addSubview(gradientBackgroundView)
        gradientBackgroundView.clipsToBounds = true
        gradientBackgroundView.isUserInteractionEnabled = false
        gradientBackgroundView.bindMarginsToSuperview()
        sendSubviewToBack(gradientBackgroundView)
    }
    
    // Tap action handler
    @objc private func didTapButton() {
        onTapAction?()
    }
    
    // Layout updates
    public override func layoutSubviews() {
        super.layoutSubviews()
        sendSubviewToBack(gradientBackgroundView)
        gradientBackgroundView.roundCorners(to: .rounded)
    }
    
    // Apply color scheme
    public func applyColorScheme(_ colorScheme: ColorScheme) {
        gradientBackgroundView.gradient = colorScheme.gradient
        tintColor = colorScheme.ctaForeground
        setTitleColor(colorScheme.ctaForeground, for: .normal)
    }
}
