//
//  UILabel+Rounded.swift
//  highlight
//
//  Created by Roi Mulia on 23/01/2020.
//  Copyright © 2020 TrendyPixel. All rights reserved.
//

import Foundation
import UIKit

public extension UILabel {
    func setRoundedSFFont() {
        guard #available(iOS 13.0, *),
              let baseFont = font,
              let fontDescriptor = baseFont.fontDescriptor.withDesign(.rounded) else {
            return
        }
        let roundedFont = UIFont(descriptor: fontDescriptor, size: baseFont.pointSize)
        font = roundedFont
    }
    
    func setCharacterSpacing(characterSpacing: CGFloat = 0.0) {
        guard let labelText = text,
              characterSpacing != 0 else {
            return
        }
        
        let attributedString: NSMutableAttributedString
        if let labelAttributedText = attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelAttributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // Character spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSMakeRange(0, attributedString.length))
        
        attributedText = attributedString
    }
    
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.lineBreakMode = lineBreakMode
        paragraphStyle.alignment = textAlignment
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}

