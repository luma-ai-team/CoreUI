//
//  UIButton+Bounce.swift
//  highlight
//
//  Created by Roi Mulia on 23/01/2020.
//  Copyright © 2020 TrendyPixel. All rights reserved.
//

import UIKit


public protocol BounceableView {
    var shouldBounceSuperview: Bool { get set }
    func addBounce()
}

public extension UIView {
    
    func addBounce() {
        isUserInteractionEnabled = true
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureAction(longPressGesture:)))
        gesture.minimumPressDuration = 0
        gesture.cancelsTouchesInView = false
        addGestureRecognizer(gesture)
        
    }
    
    @objc private func longPressGestureAction(longPressGesture: UILongPressGestureRecognizer) {
        let effectedView: UIView? = {
            if let castedView = self as? (BounceableView & UIView) {
                return castedView.shouldBounceSuperview ? superview : self
            }
            return self
        }()
        if longPressGesture.state == .began {
            UIView.animate(withDuration: 0.12, delay: 0, options: .allowUserInteraction, animations: {
                effectedView?.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
                effectedView?.alpha = 0.42
            }, completion: nil)
        }
        else if longPressGesture.state != .changed || longPressGesture.state == .ended || longPressGesture.state == .cancelled {
            
            UIView.animate(withDuration: 0.12, delay: 0, options: .allowUserInteraction, animations: {
                effectedView?.transform = CGAffineTransform.identity
                effectedView?.alpha = 1
            }, completion: nil)
        }
    }
    
}
