//
//  File.swift
//  
//
//  Created by Roi Mulia on 26/10/2020.
//

import UIKit

public enum BounceAnimationStyle: CGFloat {
    case soft = 0.01
    case medium = 0.03
    case heavy = 0.05
    case none = 0
}


public extension UIView {
        
    func applyBounceAnimation(style: BounceAnimationStyle = .heavy, startDelay: TimeInterval = 1, endDelay: TimeInterval = 1, shouldRepeat: Bool = true) {
       
        let totalDuration: Double = 0.2 + 0.17 + 0.1 + 0.2 + endDelay
        let appender: CGFloat = style.rawValue

        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.keyTimes = [0, NSNumber(value: 0.2 / totalDuration), NSNumber(value: (0.2 + 0.17) / totalDuration), NSNumber(value: (0.2 + 0.17 + 0.1) / totalDuration), 1]
        scaleAnimation.values = [1, 1 + appender, 1 - appender, 1 + appender * 0.75, 1]
        scaleAnimation.duration = totalDuration

        if shouldRepeat {
            scaleAnimation.repeatCount = .infinity
        }

        scaleAnimation.isRemovedOnCompletion = false
        scaleAnimation.fillMode = .forwards
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        let delayTime = DispatchTime.now() + startDelay
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.layer.add(scaleAnimation, forKey: nil)
        }
    }
}
