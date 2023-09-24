//
//  CircularProgressView.swift
//
//  Created by Anton Kormakov on 14.02.2023.
//

import UIKit

open class CircularGradientProgressView: UIView {
   
    public enum CircularProgressViewAnimation {
        case none
        case basic(duration: TimeInterval)
    }

    public struct CircularProgressViewAppearance {
        let emptyColor: UIColor
        let fillGradient: Gradient
        let lineWidth: CGFloat
        
        public init(emptyColor: UIColor, fillGradient: Gradient, lineWidth: CGFloat) {
            self.emptyColor = emptyColor
            self.fillGradient = fillGradient
            self.lineWidth = lineWidth
        }
    }

    let backgroundView = CircularStrokeView()
    let progressView = CircularStrokeView()
    let gradientView = GradientView()

    public var appearance: CircularProgressViewAppearance = .init(emptyColor: .red, fillGradient: .solid(.yellow), lineWidth: 10) {
        didSet {
            updateAppearance()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        progressView.progressLayer.strokeEnd = 0
        
        addSubview(backgroundView)
        addSubview(gradientView)
        backgroundView.bindMarginsToSuperview()
        gradientView.bindMarginsToSuperview()
        updateAppearance()
    }

    private func updateAppearance() {
        for view in [backgroundView, progressView] {
            view.progressLayer.lineWidth = appearance.lineWidth
        }
        
        backgroundView.progressLayer.strokeColor = appearance.emptyColor.cgColor
        gradientView.gradient = appearance.fillGradient
        
        backgroundView.setNeedsLayout()
        progressView.setNeedsDisplay()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        progressView.frame = bounds
        gradientView.mask = progressView
    }

    public func setProgress(progress: Float, animation: CircularProgressViewAnimation) {
        let strokeEnd = CGFloat(progress.clamped(min: 0.0, max: 1.0))
        if case .basic(let duration) = animation {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = duration
            animation.toValue = strokeEnd
            animation.timingFunction = CAMediaTimingFunction(name: .linear)
            animation.isRemovedOnCompletion = true
            progressView.progressLayer.add(animation, forKey: animation.keyPath)
        }
        progressView.progressLayer.strokeEnd = strokeEnd
    }
    

}

