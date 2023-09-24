//
//  File.swift
//  
//
//  Created by OZ on 9/24/23.
//

import UIKit


public class CircularStrokeView: UIView {

    lazy var progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = .round
        layer.strokeColor = UIColor.green.cgColor
        layer.strokeEnd = 1
        layer.lineWidth = 4
        return layer
    }()

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
        layer.addSublayer(progressLayer)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        
        let lineWidth = progressLayer.lineWidth
        let frameMinusLineWidth = bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2)

        let arcCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        
        let path = UIBezierPath(arcCenter: arcCenter,
                                radius: min(frameMinusLineWidth.width, frameMinusLineWidth.height) / 2,
                                startAngle: 0.0, endAngle: .pi * 2.0,
                                clockwise: true)

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        progressLayer.path = path.cgPath
        progressLayer.bounds = bounds
        progressLayer.setAffineTransform(.init(rotationAngle: -0.5 * .pi))
        progressLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        CATransaction.commit()
    }
}
