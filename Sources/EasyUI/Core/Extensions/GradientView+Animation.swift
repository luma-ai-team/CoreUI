//
//  File.swift
//  
//
//  Created by OZ on 8/29/23.
//

import UIKit

extension GradientView {
    public func animate(to newGradient: Gradient, duration: TimeInterval = 0.3) {
        guard let gradientLayer = layer as? CAGradientLayer else {
            return
        }
        
        let colorAnimation : CABasicAnimation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.colors))
        colorAnimation.toValue = newGradient.colors.map {$0.cgColor}
        colorAnimation.fromValue = gradient.colors.map {$0.cgColor}
        colorAnimation.duration = duration
        colorAnimation.fillMode = .forwards
        colorAnimation.isRemovedOnCompletion = true
        colorAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        gradientLayer.colors = newGradient.colors.map {$0.cgColor}
      
        layer.add(colorAnimation, forKey: nil)
        gradient = newGradient
    }
}
