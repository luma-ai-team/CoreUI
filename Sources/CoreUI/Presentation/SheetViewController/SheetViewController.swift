//
//  File.swift
//  
//
//  Created by Roi Mulia on 28/01/2021.
//

import UIKit


open class SheetViewController: ContentableViewController {

    
    private var transition = SheetTransition()

    public override var contentView: ContentableView {
        didSet {
            setContentView(contentView, animated: true)
        }
    }


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
        NSLayoutConstraint.activate([
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.roundCorners(to: .custom(appearance.cornerRadius))
        containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        containerView.clipsToBounds = true
        containerView.layer.masksToBounds = true
    }

    open func setContentView(_ contentView: ContentableView, animated: Bool) {
        containerView.addSubview(contentView)
        contentView.bindFrameToSuperviewBounds()
        UIView.performWithoutAnimation {
            contentView.layoutIfNeeded()
        }

        guard animated else {
            if self.contentView !== contentView {
                self.contentView.removeFromSuperview()
            }
            super.contentView = contentView
            contentView.postAppearanceActions()
            containerView.bringSubviewToFront(self.closeButton)
            return
        }

        contentView.alpha = 0

        self.contentView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        self.contentView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        UIView.animate(withDuration: 0.2) {
            self.contentView.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { (_) in
            if self.contentView !== contentView {
                self.contentView.removeFromSuperview()
            }
            super.contentView = contentView
            UIView.animate(withDuration: 0.2) {
                self.contentView.alpha = 1
                self.view.layoutIfNeeded()
            } completion: { (_) in
                self.contentView.postAppearanceActions()
                self.containerView.bringSubviewToFront(self.closeButton)
            }
        }
    }
}

