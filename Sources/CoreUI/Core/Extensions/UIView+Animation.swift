//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit

extension UIView {

    static func defaultSpringAnimation(_ animations: @escaping (() -> Void)) {
        defaultSpringAnimation(duration: 0.35, animations: animations)
    }

    static func defaultSpringAnimation(duration: TimeInterval = 0.35,
                                       delay: TimeInterval = 0.0,
                                       animations: @escaping (() -> Void),
                                       completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       usingSpringWithDamping: 0.95,
                       initialSpringVelocity: 0.5,
                       options: [],
                       animations: {
            animations()
        }, completion: completion)
    }

    func layout() {
        setNeedsLayout()
        layoutIfNeeded()
    }

    func setHidden(_ isHidden: Bool, animated: Bool) {
        guard self.isHidden != isHidden else {
            return
        }
        
        layer.removeAllAnimations()
        guard animated else {
            self.isHidden = isHidden
            return
        }

        let sourceAlpha = alpha
        if isHidden {
            UIView.defaultSpringAnimation(animations: {
                self.alpha = 0
            }, completion: { (isFinished: Bool) in
                guard isFinished else {
                    return
                }

                self.isHidden = isHidden
                self.alpha = sourceAlpha
            })
        }
        else {
            alpha = 0
            self.isHidden = false
            UIView.defaultSpringAnimation {
                self.alpha = sourceAlpha
            }
        }
    }
}
