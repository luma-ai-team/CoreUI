//
//  Alert.swift
//  AlertTryout
//
//  Created by Roi Mulia on 25/01/2023.
//

import Foundation
import UIKit

open class AlertViewController: PopupViewController {

    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterialLight))
    let alertContentView: AlertContentView
    public var shouldDismissOnDimmedViewTap = false
    
    public init() {
        let alertContentView: AlertContentView = UIView.fromNib(bundle: .module)
        self.alertContentView = alertContentView
        let appearance = ContentableViewAppearance(
            backgroundColor: .red,
            closeTintColor: .red,
            closeImage: nil,
            viewBackgroundStyle: .color(.black.withAlphaComponent(0.5)),
            cornerRadius: 13)
        super.init(initWith: alertContentView, appearance: appearance)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        contentView.backgroundColor = .clear
        containerView.backgroundColor = .clear
        centerYConstraint?.constant = -24
        contentView.addSubview(visualEffectView)
        visualEffectView.bindMarginsToSuperview()
        contentView.sendSubviewToBack(visualEffectView)
        closeButton.alpha = 0
    }
    
    public func display(model: AlertViewModel, animated: Bool) {
        visualEffectView.effect = model.appearance.theme.visualEffect
        visualEffectView.contentView.backgroundColor = model.appearance.theme == .light ?
            UIColor.white.withAlphaComponent(0.2) :
            UIColor.black.withAlphaComponent(0.2)

        alertContentView.update(with: model, animated: animated)

        view.setNeedsLayout()
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    public func dismiss(delay: CGFloat) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.dismiss(animated: true)
        }
    }
    
    open override func viewDimmedTapped() {
        guard shouldDismissOnDimmedViewTap else {
            return
        }
        self.dismiss(animated: true)
    }
}

