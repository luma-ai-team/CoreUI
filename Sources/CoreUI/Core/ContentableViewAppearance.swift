//
//  File.swift
//  
//
//  Created by Roi Mulia on 21/11/2020.
//

import UIKit

public struct ContentableViewAppearance {
    
    public enum BackgroundStyle {
        case color(UIColor)
        case blur(UIBlurEffect.Style)
    }
    
    let backgroundColor: UIColor
    let closeTintColor: UIColor
    let closeImage: UIImage?
    let cornerRadius: CGFloat
    let viewBackgroundStyle: BackgroundStyle
    
    public init(backgroundColor: UIColor, closeTintColor: UIColor, closeImage: UIImage?, viewBackgroundStyle: BackgroundStyle, cornerRadius: CGFloat = 24) {
        self.backgroundColor = backgroundColor
        self.closeTintColor = closeTintColor
        self.closeImage = closeImage
        self.cornerRadius = cornerRadius
        self.viewBackgroundStyle = viewBackgroundStyle
    }
}

