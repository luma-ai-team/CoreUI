//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import UIKit

open class BounceButton: UIButton, UIGestureRecognizerDelegate {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        adjustsImageWhenHighlighted = false
        let gestureRecognizer = addBounce()
        gestureRecognizer.delegate = self
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true 
    }
}
