//
//  File.swift
//  
//
//  Created by Eilon Krauthammer on 17/01/2021.
//

import UIKit


public protocol ReviewControllerOutput: AnyObject {
    func reviewViewControllerCtaTapped(_ reviewViewController: ReviewViewController)
}

open class ReviewViewController: PopupViewController {
    
    // MARK: - Outlets
    public weak var output: ReviewControllerOutput?
    
    let reviewContentView: ReviewContentView
    
    public init(configuration: ReviewViewController.Configuration) {
        let reviewContentView = ReviewContentView.create(with: configuration)
        self.reviewContentView = reviewContentView
        let appearance = ContentableViewAppearance(
            backgroundColor: configuration.appearance.backgroundColor,
            closeTintColor: configuration.appearance.closeTint,
            closeImage: nil,
            viewBackgroundStyle: .color(.black.withAlphaComponent(0.7)))
        super.init(initWith: reviewContentView, appearance: appearance)
        reviewContentView.delegate = self
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func closeTapped() {
        dismiss(animated: true)
    }
    
    open override func viewDimmedTapped() {
        dismiss(animated: true)
    }
}

public extension ReviewViewController {
    struct Configuration {
        public struct Appearance {
            let backgroundColor: UIColor
            let closeTint: UIColor
            let titleColor, subtitleColor: UIColor
            let titleFont, subtitleFont: UIFont
            let starsGradient: Gradient
            let ctaTextColor: UIColor
            let ctaBackgroundGradient: Gradient
            
            public init(backgroundColor: UIColor, closeTint: UIColor, titleColor: UIColor, subtitleColor: UIColor, titleFont: UIFont, subtitleFont: UIFont, starsGradient: Gradient, ctaTextColor: UIColor, ctaBackgroundGradient: Gradient) {
                self.backgroundColor = backgroundColor
                self.closeTint = closeTint
                self.titleColor = titleColor
                self.subtitleColor = subtitleColor
                self.titleFont = titleFont
                self.subtitleFont = subtitleFont
                self.starsGradient = starsGradient
                self.ctaTextColor = ctaTextColor
                self.ctaBackgroundGradient = ctaBackgroundGradient
            }
        }
        
        public init(title: String, subtitle: String, ctaTitle: String, appearance: Appearance) {
            self.title = title
            self.subtitle = subtitle
            self.ctaTitle = ctaTitle
            self.appearance = appearance
        }
        
        let title: String
        let subtitle: String
        let ctaTitle: String
        let appearance: Appearance
    }
    
    static func create(
        title: String,
        subtitle: String,
        ctaTitle: String = "Review 5 Stars to Unlock",
        colorScheme: ColorScheme) -> ReviewViewController {
            let appeanrace = Configuration.Appearance(
                backgroundColor: colorScheme.foreground,
                closeTint: colorScheme.subtitle,
                titleColor: colorScheme.title,
                subtitleColor: colorScheme.subtitle,
                titleFont: UIFont.roundedFont(size: 24, weight: .semibold),
                subtitleFont: UIFont.roundedFont(size: 16
                                                 , weight: .regular),
                starsGradient: .solid(UIColor(hex: "ED8834")),
                ctaTextColor: colorScheme.ctaForeground,
                ctaBackgroundGradient: colorScheme.gradient)
            return ReviewViewController(configuration: .init(title: title, subtitle: subtitle, ctaTitle: ctaTitle, appearance: appeanrace))
        
    }
}


extension ReviewViewController: ReviewContentViewDelegate {
    func reviewContentViewCtaTapped(_ reviewContentView: ReviewContentView) {
        output?.reviewViewControllerCtaTapped(self)
    }
}
