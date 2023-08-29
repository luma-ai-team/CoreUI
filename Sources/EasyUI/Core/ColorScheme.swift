//
//  File.swift
//  
//
//  Created by Roi Mulia on 08/11/2022.
//

import UIKit


open class ColorScheme {
    public let active: UIColor
    public let title: UIColor
    public let subtitle: UIColor
    public let notActive: UIColor
    public let background: UIColor
    public let foreground: UIColor
    public let disabled: UIColor
    public let ctaForeground: UIColor
    public var destructive: UIColor
    public let gradient: Gradient
    
    public init(
        active: UIColor,
        title: UIColor,
        subtitle: UIColor,
        notActive: UIColor,
        background: UIColor,
        foreground: UIColor,
        disabled: UIColor,
        ctaForeground: UIColor,
        destrctive: UIColor = UIColor.systemRed,
        gradient: Gradient) {
            self.active = active
            self.title = title
            self.subtitle = subtitle
            self.notActive = notActive
            self.background = background
            self.disabled = disabled
            self.gradient = gradient
            self.foreground = foreground
            self.ctaForeground = ctaForeground
            self.destructive = destrctive
        }
}


