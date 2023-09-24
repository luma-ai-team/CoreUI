//
//  CircularProgressView.swift
//
//  Created by Anton Kormakov on 14.02.2023.
//

import UIKit

open class CircularProgressView: UIView {
    public enum Animation {
        case none
        case basic(duration: TimeInterval)
    }

    public struct CircularProgressViewAppearance {
        let emptyColor: UIColor
        let fillColor: UIColor
        let lineWidth: CGFloat
        
        public init(emptyColor: UIColor, fillColor: UIColor, lineWidth: CGFloat) {
            self.emptyColor = emptyColor
            self.fillColor = fillColor
            self.lineWidth = lineWidth
        }
    }

    private lazy var backgroundLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()

    private lazy var progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = .round
        layer.strokeEnd = 0
        return layer
    }()

    public var appearance: CircularProgressViewAppearance = .init(emptyColor: .red, fillColor: .blue, lineWidth: 10) {
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
        backgroundColor = .clear
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(progressLayer)
        updateAppearance()
    }

    private func updateAppearance() {
        backgroundLayer.strokeColor = appearance.emptyColor.cgColor
        backgroundLayer.lineWidth = appearance.lineWidth

        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = appearance.fillColor.cgColor
        progressLayer.lineWidth = appearance.lineWidth
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0,
                                                   y: frame.size.height / 2.0),
                                radius: min(bounds.width, bounds.height) / 2,
                                startAngle: 0.0, endAngle: .pi * 2.0,
                                clockwise: true)

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        progressLayer.bounds = bounds
        progressLayer.setAffineTransform(.init(rotationAngle: -0.5 * .pi))
        progressLayer.position = .init(x: bounds.midX, y: bounds.midY)
        progressLayer.path = path.cgPath

        backgroundLayer.frame = bounds
        backgroundLayer.path = path.cgPath
        CATransaction.commit()
    }

    func setProgress(progress: Float, animation: Animation) {
        let strokeEnd = CGFloat(progress.clamped(min: 0.0, max: 1.0))
        if case .basic(let duration) = animation {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = duration
            animation.toValue = strokeEnd
            animation.timingFunction = CAMediaTimingFunction(name: .linear)
            animation.isRemovedOnCompletion = true
            progressLayer.add(animation, forKey: animation.keyPath)
        }
        progressLayer.strokeEnd = strokeEnd
    }
}
