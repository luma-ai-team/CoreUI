
import UIKit


open class CTAButton: GradientButton {
    
    // UI Elements
    public var colorScheme: ColorScheme?
    public var hitTestPadding: UIEdgeInsets?

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
        self.colorScheme = colorScheme
        setActiveState()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonSetup()
    }
    
    // Common UI setup
     func commonSetup() {
         addBounce()
        hitTestPadding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    // Tap action handler
    @objc private func didTapButton() {
        onTapAction?()
    }
    
    // Apply color scheme
    public func setActiveState() {
        isUserInteractionEnabled = true
        guard let colorScheme = colorScheme else {
            return
        }
        backgroundGradient = colorScheme.gradient
        tintColor = colorScheme.ctaForeground
        setTitleColor(colorScheme.ctaForeground, for: .normal)
        titleGradient = .solid(colorScheme.ctaForeground)
    }
    
    public func setDisabledState() {
        isUserInteractionEnabled = false
        guard let colorScheme = colorScheme else {
            return
        }
        backgroundGradient = .solid(colorScheme.disabled)
        tintColor = colorScheme.title.withAlphaComponent(0.2)
        setTitleColor(colorScheme.title.withAlphaComponent(0.2), for: .normal)
        titleGradient = .solid(colorScheme.title.withAlphaComponent(0.2))
    }

    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitTestPadding = hitTestPadding, isUserInteractionEnabled {
            let adjustedFrame = bounds.inset(by: .init(top: -hitTestPadding.top, left: -hitTestPadding.left, bottom: -hitTestPadding.bottom, right: -hitTestPadding.right))
            if adjustedFrame.contains(point) {
                return self
            }
        }
        
        return super.hitTest(point, with: event)
    }
}
