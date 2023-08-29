//
//  UIButton+GradientableButton.swift
//  TestProject
//
//  Created by Roi Mulia on 21/09/2020.
//  Copyright © 2020 Roi Mulia. All rights reserved.
//

import UIKit


public protocol GradientableButton: GradientableView  {
    var fakeButton: UIButton { get set }
    var buttonGradientableViews: ButtonGradientableViews { get set }
    var titleGradientView: GradientView { get set }
    var cornerRadiusStyle: CornerRadiusStyle { get set }
    func updateFakeButtonProperties()
}

public extension GradientableButton where Self: UIButton {

    func initGradientableProperties() {
        if #available(iOS 15.0, *) {
            configuration = .none
        } 
        fakeButton.isUserInteractionEnabled = false
        backgroundGradeintView.isUserInteractionEnabled = false
        titleGradientView.isUserInteractionEnabled = false
        backgroundColor = .clear
        addSubview(fakeButton)
        addSubview(backgroundGradeintView)
        addSubview(titleGradientView)
        // dummy color, will be override by mask
        backgroundColor = .clear
    }
    
    func updateGradientableProperties() {
        backgroundGradeintView.frame = bounds
        updateFakeButtonProperties()

        titleGradientView.frame = bounds
        titleGradientView.subviews.forEach {$0.removeFromSuperview()}
        switch buttonGradientableViews {
        case .title:
            titleGradientView.frame = titleLabel?.frame ?? .zero
            fakeButton.titleLabel?.frame = titleGradientView.frame
            let cover = UIView()
            cover.backgroundColor = titleColor(for: .normal)
            titleGradientView.addSubview(cover)
            cover.frame = titleLabel?.frame ?? .zero
        case .image:
            let cover = UIView()
            cover.backgroundColor = titleColor(for: .normal)
            titleGradientView.addSubview(cover)
            cover.frame = titleLabel?.frame ?? .zero
        case .all:
            titleGradientView.frame = bounds
        }
        titleGradientView.mask = fakeButton
        updateFakeButtonProperties()


        backgroundGradeintView.setNeedsDisplay()
        titleGradientView.setNeedsDisplay()
    }
    
    func updateFakeButtonProperties() {
        fakeButton.frame = bounds
        fakeButton.setTitle(title(for: .normal), for: .normal)
        fakeButton.setImage(imageView?.image, for: .normal)
        fakeButton.setTitleColor(titleLabel?.textColor, for: .normal)
        fakeButton.tintColor = tintColor
        fakeButton.titleLabel?.font = titleLabel?.font
        fakeButton.contentEdgeInsets = contentEdgeInsets
        fakeButton.imageEdgeInsets = imageEdgeInsets
        fakeButton.titleEdgeInsets = titleEdgeInsets
        fakeButton.titleLabel?.numberOfLines = titleLabel?.numberOfLines ?? 1
        fakeButton.titleLabel?.lineBreakMode = titleLabel?.lineBreakMode ?? UILabel().lineBreakMode
        fakeButton.titleLabel?.textAlignment = titleLabel?.textAlignment ?? .center
        fakeButton.imageView?.frame = imageView?.frame ?? fakeButton.imageView?.frame ?? .zero
        fakeButton.titleLabel?.frame = titleLabel?.frame ?? fakeButton.titleLabel?.frame ?? .zero
        imageView?.alpha = 0
        titleLabel?.alpha = 0
        imageView?.isHidden = true
        titleLabel?.isHidden = true
    }
    
}

