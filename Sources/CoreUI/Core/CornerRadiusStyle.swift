//
//  File.swift
//  
//
//  Created by Roi Mulia on 21/01/2021.
//

import UIKit

public enum CornerRadiusStyle: Equatable {
    enum Masking {
        case topHorizontal
        case bottomHorizontal
        case rightVertical
        case leftVertical
        case leftToRightDiagonal
        case rightToLeftDiagnonal
        case custom(CACornerMask)
    }
    
    public static func == (lhs: CornerRadiusStyle, rhs: CornerRadiusStyle) -> Bool {
        switch (lhs, rhs) {
            case (.rounded, .rounded):
                return true
            case (.custom(let a), .custom(let b)):
                return a == b
            default:
                return false
        }
    }
    
    case rounded
    case custom(CGFloat)
    case other(UIView)
}
