//
//  File.swift
//  
//
//  Created by Roi Mulia on 20/10/2020.
//

import Foundation
import UIKit


open class BounceSuperViewButton: UIButton, BounceableView {
    public var shouldBounceSuperview: Bool = true
    
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
