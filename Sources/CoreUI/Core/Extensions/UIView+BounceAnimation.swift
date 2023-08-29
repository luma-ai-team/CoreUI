//
//  File.swift
//  
//
//  Created by Roi Mulia on 26/10/2020.
//

import UIKit



public extension UIView {
    
    enum BounceAnimationStyle: CGFloat {
        case soft = 0.01
        case medium = 0.03
        case heavy = 0.05
        case none = 0
    }
    
    
    func applyBounceAnimation(style: BounceAnimationStyle = .heavy, startDelay: TimeInterval = 1, endDelay: TimeInterval = 1, shouldRepeat: Bool = true) {
       
        var options: UIView.KeyframeAnimationOptions {
            if shouldRepeat {
                return  [.allowUserInteraction, .repeat]
            }
            return [.allowUserInteraction]
        }
        
        let totalDuration: Double = 0.2 + 0.17 + 0.1 + 0.2 + endDelay
        let appender: CGFloat = style.rawValue
        UIView.animateKeyframes(withDuration: totalDuration, delay: startDelay, options: options, animations: {
            
            var relativeStartTime: Double = 0
            
            UIView.addKeyframe(withRelativeStartTime: relativeStartTime, relativeDuration: 0.2 / totalDuration) {
                self.transform = .init(scaleX: 1 + appender, y: 1 + appender)
            }
            
            relativeStartTime +=  0.2 / totalDuration
            UIView.addKeyframe(withRelativeStartTime: relativeStartTime , relativeDuration: 0.17 / totalDuration) {
                self.transform = .init(scaleX: 1 - appender, y: 1 - appender)
            }
            
            relativeStartTime +=  0.17 / totalDuration
            UIView.addKeyframe(withRelativeStartTime: relativeStartTime , relativeDuration: 0.1 / totalDuration) {
                self.transform = .init(scaleX: 1 + appender * (0.75), y: 1 + appender * (0.75))
            }
            
            relativeStartTime +=  0.1 / totalDuration
            UIView.addKeyframe(withRelativeStartTime: relativeStartTime , relativeDuration: 0.2 / totalDuration) {
                self.transform = .identity
            }
            
        }, completion: nil)
    }
}
