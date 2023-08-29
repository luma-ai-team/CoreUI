//
//  UIViewController+Extensions.swift
//  highlight
//
//  Created by Roi Mulia on 22/01/2020.
//  Copyright © 2020 TrendyPixel. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
    func addAsChildTo(parentVc: UIViewController, inside container: UIView, insets: UIEdgeInsets = .zero) {
        parentVc.addChild(self)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(self.view)
        
        view.bindMarginsToSuperview(insets: insets)
        didMove(toParent: parentVc)
    }
    
    func removeChildViewController() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    func addAsSafeAreaChildTo(parentVc: UIViewController, inside container: UIView) {
          parentVc.addChild(self)
          self.view.translatesAutoresizingMaskIntoConstraints = false
          container.addSubview(self.view)
          
          view.bindMarginsToSuperviewWithBottomSafeArea()
          didMove(toParent: parentVc)
      }
    
    static func getTopViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
     }
    
}

