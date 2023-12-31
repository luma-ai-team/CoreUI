//
//  File.swift
//  
//
//  Created by Nir Endy on 31/12/2023.
//

import UIKit

public extension AlertViewController {
    func makeErrorAndDismissViewModel(title: String, colorScheme: ColorScheme) -> AlertViewModel {
        let dismissAction = AlertAction(image: nil, title: "Okay", style: .default) { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        let action = AlertActionsInfo.init(buttonAxis: .horizontal, actions: [dismissAction])
        let alertViewModel = AlertViewModel(title: title, subtitle: "Please try again.", visualAid: .none, actionsInfo: action, colorScheme: colorScheme)
        return alertViewModel
    }
}
     

public extension AlertViewController {
    static func loadingAlertViewController(title: String, colorScheme: ColorScheme) -> AlertViewController {
        let loadingViewController = AlertViewController()
        let loadingAlertModel = AlertViewModel(title: title, subtitle: nil, visualAid: .spinner, actionsInfo: nil, colorScheme: colorScheme)
        loadingViewController.display(model: loadingAlertModel, animated: false)
        return loadingViewController
    }
    
    static func loadingCancelableAlertViewController(title: String, colorScheme: ColorScheme, cancelClosure:  (()->Void)?) -> AlertViewController {
        let loadingViewController = AlertViewController()
        let action = AlertAction(title: "Cancel", style: .cancel) { [weak loadingViewController] in
            cancelClosure?()
            loadingViewController?.dismiss(animated: true)
        }
        let loadingAlertModel = AlertViewModel(title: title, subtitle: nil, visualAid: .spinner, actionsInfo: .init(buttonAxis: .horizontal, actions: [action]), colorScheme: colorScheme)
        loadingViewController.display(model: loadingAlertModel, animated: false)
        return loadingViewController
    }
}
                                    
                                    
