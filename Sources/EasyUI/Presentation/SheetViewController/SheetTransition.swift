//
//  OrgTransition.swift
//  PresentationViewSample
//
//  Created by hirauchi.shinichi on 2017/02/18.
//  Copyright © 2017年 SAPPOROWORKS. All rights reserved.
//

import UIKit

class SheetTransition: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning{
    
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
        return 0.225
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
              let to = transitionContext.viewController(forKey: .to) as? SheetViewController  else {
            return
        }
        
        from.view.layoutIfNeeded()
        to.view.layoutIfNeeded()
        to.contentView.layoutIfNeeded()
        to.containerView.layoutIfNeeded()
        to.backgroundView.alpha = 0

        let containerView = transitionContext.containerView
        containerView.insertSubview(to.view, belowSubview: from.view)
        to.view.backgroundColor = .clear
        to.view.alpha = 1
        
        let height = to.containerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        to.containerView.transform = .init(translationX: 0, y: height)

        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            to.containerView.transform = .identity
            to.backgroundView.alpha = 1
            to.view.layoutIfNeeded()
            from.view.layoutIfNeeded()
        }, completion: {
            finished in
            transitionContext.completeTransition(true)
        })

    }
    
    func animateDissmissalTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let from = transitionContext.viewController(forKey: .from) as? SheetViewController,
            let to = transitionContext.viewController(forKey: .to) else {
                return
        }
        
        let containerView = from.containerView
        from.view.layoutIfNeeded()
        to.view.layoutIfNeeded()
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            from.backgroundView.alpha = 0
            from.view.backgroundColor = .clear
            containerView.transform = .init(translationX: 0, y: containerView.frame.height)
            from.view.layoutIfNeeded()
            to.view.layoutIfNeeded()
            
            
        }, completion: {
            finished in
            transitionContext.completeTransition(true)
        })
    }
    
}
