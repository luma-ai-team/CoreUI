//
//  GradientButtonV2.swift
//  Gradient
//
//  Created by Roi Mulia on 17/12/2019.
//  Copyright © 2019 Craftiz. All rights reserved.
//

import UIKit

public enum ButtonGradientableViews {
    case title
    case image
    case all
}


public protocol GradientableView {
    var backgroundBorderWidth: CGFloat { get set }
    var shouldFillBackgroundView: Bool { get set }
    var backgroundGradeintView: GradientView { get set }
    func initGradientableProperties()
    func updateGradientableProperties()
    
}

