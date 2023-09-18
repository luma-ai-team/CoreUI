//
//  File.swift
//  
//
//  Created by Roi Mulia on 05/02/2023.
//

import UIKit


open class ExtendedHitTestButton: BounceButton {
    
    public var hitTestPadding: UIEdgeInsets?


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

