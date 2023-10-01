//
//  UIButton+Bounce.swift
//  highlight
//
//  Created by Roi Mulia on 23/01/2020.
//  Copyright © 2020 TrendyPixel. All rights reserved.
//

import UIKit

public extension UIView {
    
    @discardableResult func addBounce() -> UILongPressGestureRecognizer {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleGesture))
        gesture.minimumPressDuration = 0
        gesture.cancelsTouchesInView = false
        isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
        return gesture
    }
    
    @objc private func handleGesture(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            bounce(true)
        case .ended, .cancelled:
            bounce(false)
        default:
            break
        }
    }
    
    private func bounce(_ shouldBounceIn: Bool) {
        let animationKey = "bounce"
        let alphaKey = "alphaChange"
        
        let bounceScale: CGFloat = 0.9
        let alphaValue: CGFloat = 0.3
        let duration: TimeInterval = 0.1
        layer.removeAnimation(forKey: animationKey)
        layer.removeAnimation(forKey: alphaKey)
        
        // Scale animation
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.values = shouldBounceIn ? [1.0, bounceScale] : [bounceScale, 1.0]
        scaleAnimation.keyTimes = [0, 1]
        scaleAnimation.timingFunctions = [CAMediaTimingFunction(name: .easeInEaseOut)]
        scaleAnimation.duration = duration
        scaleAnimation.isRemovedOnCompletion = false
        scaleAnimation.fillMode = .forwards
        
        // Alpha animation
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.fromValue = shouldBounceIn ? 1.0 : alphaValue
        alphaAnimation.toValue = shouldBounceIn ? alphaValue : 1.0
        alphaAnimation.duration = duration
        alphaAnimation.isRemovedOnCompletion = false
        alphaAnimation.fillMode = .forwards
        
        layer.add(scaleAnimation, forKey: animationKey)
        layer.add(alphaAnimation, forKey: alphaKey)
    }
    
}
