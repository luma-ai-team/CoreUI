//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import UIKit

open class BounceButton: UIButton {    
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
        addBounce()
    }
}
