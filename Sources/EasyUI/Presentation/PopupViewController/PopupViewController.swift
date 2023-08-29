//
//  popupViewController.swift
//  layer
//
//  Created by Roi Mulia on 05/08/2019.
//  Copyright © 2019 Craftiz. All rights reserved.
//

import UIKit


open class PopupViewController: ContentableViewController {
    
    private var transition = PopupTransition()
        
    public var centerXConstraint: NSLayoutConstraint?
    public var centerYConstraint: NSLayoutConstraint?
    
    public override init(initWith contentView: ContentableView, appearance: ContentableViewAppearance) {
        super.init(initWith: contentView, appearance: appearance)
        modalPresentationStyle = .overFullScreen
        self.transitioningDelegate = transition
    }

    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout cycle
     
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerViewConstraints()
    }

    open func setupContainerViewConstraints() {
        let centerXConstraint = containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let centerYConstraint = containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)

        NSLayoutConstraint.activate([
            centerXConstraint,
            centerYConstraint
        ])
        
        self.centerYConstraint = centerYConstraint
        self.centerXConstraint = centerXConstraint
    }

    open override func viewDimmedTapped() {
        // ignore
    }
}
