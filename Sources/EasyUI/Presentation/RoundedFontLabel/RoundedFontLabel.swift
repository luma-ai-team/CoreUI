//
//  RoundedFontLabel.swift
//  TestProject
//
//  Created by Roi Mulia on 21/09/2020.
//  Copyright © 2020 Roi Mulia. All rights reserved.
//

import UIKit

open class RoundedFontLabel: UILabel {
    
    @IBInspectable public var spacing: CGFloat = 0 {
        didSet {
            setCharacterSpacing(characterSpacing: spacing)
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setRoundedSFFont()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setRoundedSFFont()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        setCharacterSpacing(characterSpacing: spacing)
    }
}
