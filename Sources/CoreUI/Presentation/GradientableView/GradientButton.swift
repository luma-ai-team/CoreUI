//
//  File.swift
//  
//
//  Created by Anton Kormakov on 15.12.2020.
//

import UIKit


open class GradientButton: UIButton, GradientableButton {
    
    public var cornerRadiusStyle = CornerRadiusStyle.rounded
    
    public lazy var fakeButton: UIButton = .init(type: .custom)
    public var buttonGradientableViews: ButtonGradientableViews = .all
    
    public var titleGradientView: GradientView = .init()
    public var backgroundGradeintView: GradientView = .init()
    
    public var backgroundBorderWidth: CGFloat = 0.0
    public var shouldFillBackgroundView: Bool = true
    
    public var backgroundGradient: Gradient {
        get {
            return backgroundGradeintView.gradient
        }
        set {
            backgroundGradeintView.gradient = newValue
        }
    }
    
    
    public var titleGradient: Gradient {
        get {
            return titleGradientView.gradient
        }
        set {
            titleGradientView.gradient = newValue
        }
    }
 
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initGradientableProperties()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initGradientableProperties()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientableProperties()
        backgroundGradeintView.clipsToBounds = true
        backgroundGradeintView.roundCorners(to: cornerRadiusStyle)
    }
}
