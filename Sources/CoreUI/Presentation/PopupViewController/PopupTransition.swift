//
//  OrgTransition.swift
//  PresentationViewSample
//
//  Created by hirauchi.shinichi on 2017/02/18.
//  Copyright © 2017年 SAPPOROWORKS. All rights reserved.
//

import UIKit

class PopupTransition: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning{
    
    fileprivate var isPresent = false
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.28
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            animatePresentTransition(transitionContext: transitionContext)
        } else {
            animateDissmissalTransition(transitionContext: transitionContext)
        }
    }
    
    // 遷移時のTrastion処理
    func animatePresentTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let from = transitionContext.viewController(forKey: .from) ,
              let to = transitionContext.viewController(forKey: .to) as? ContentableViewController  else {
            return
        }
        
        from.view.layoutIfNeeded()
        to.view.layoutIfNeeded()
        to.contentView.layoutIfNeeded()
        to.containerView.layoutIfNeeded()
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(to.view, belowSubview: from.view)
        to.view.backgroundColor = .clear
        to.view.alpha = 1
        to.backgroundView.alpha = 0
        to.containerView.alpha = 0
        to.containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.85, options: UIView.AnimationOptions.allowUserInteraction) {
            to.containerView.transform = .identity
            to.containerView.alpha = 1
        }
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            to.backgroundView.alpha = 1
            to.view.layoutIfNeeded()
            from.view.layoutIfNeeded()
        }, completion: {
            finished in
            to.contentView.postAppearanceActions()
            transitionContext.completeTransition(true)
        })

    }
    
    func animateDissmissalTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let from = transitionContext.viewController(forKey: .from) as? ContentableViewController,
            let to = transitionContext.viewController(forKey: .to) else {
                return
        }
        
        let containerView = from.containerView
        from.view.layoutIfNeeded()
        to.view.layoutIfNeeded()
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            from.view.layoutIfNeeded()
            to.view.layoutIfNeeded()
            containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            containerView.alpha = 0
            from.backgroundView.alpha = 0
        }, completion: {
            finished in
            transitionContext.completeTransition(true)
        })
    }
    
}
