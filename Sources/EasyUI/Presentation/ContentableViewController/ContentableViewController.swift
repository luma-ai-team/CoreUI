//
//  File.swift
//  
//
//  Created by Roi Mulia on 28/01/2021.
//

import UIKit

public protocol ContentableViewControllerDelegate: AnyObject {
    func contentableViewControllerCloseTapped(_ contentableViewController: ContentableViewController)
    func contentableViewControllerViewDimmedTapped(_ contentableViewController: ContentableViewController)
}


open class ContentableViewController: UIViewController {
    
    public weak var delegate: ContentableViewControllerDelegate?
    
    public let containerView = UIView()
    public let closeButton = BounceButton()
    
    
    let appearance: ContentableViewAppearance
    public var contentView: ContentableView
    let backgroundView: UIView
    
    public init(initWith contentView: ContentableView, appearance: ContentableViewAppearance) {
        self.appearance = appearance
        self.contentView = contentView
        self.backgroundView = Self.getView(for: appearance.viewBackgroundStyle)
        super.init(nibName: nil , bundle: nil)
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout cycle
     
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewDimmedTapped))
        tapGesture.delegate = self
        backgroundView.isUserInteractionEnabled = true
        backgroundView.addGestureRecognizer(tapGesture)
        view.backgroundColor = .clear
        closeButton.addTarget(self, action: #selector(self.closeTapped), for: .touchUpInside)
        contentView.isUserInteractionEnabled = true
        
        setupUI()
        updateAppearance()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.bringSubviewToFront(closeButton)
    }
    
    func setupUI() {
        view.addSubview(backgroundView)
        view.addSubview(containerView)
        containerView.addSubview(closeButton)
        containerView.addSubview(contentView)
        
        backgroundView.bindMarginsToSuperview()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.bindMarginsToSuperview()
        // CloseButton
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.contentEdgeInsets = .init(top: 6, left: 10, bottom: 6, right: 10)
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
        ])
    }
    
    func updateAppearance() {
        containerView.roundCorners(to: .custom(appearance.cornerRadius))
        contentView.roundCorners(to: .custom(appearance.cornerRadius))
        contentView.clipsToBounds = true
        //containerView.clipsToBounds = true
        //containerView.layer.masksToBounds = true
        containerView.backgroundColor = appearance.backgroundColor
        
        closeButton.setImage(appearance.closeImage  ?? UIImage(named: "closePopup", in: .module, compatibleWith: nil), for: .normal)
        closeButton.tintColor = appearance.closeTintColor
        closeButton.sizeToFit()
        
        contentView.backgroundColor = .clear
    }
    
    // MARK: - Actions
    
    @objc open  func closeTapped() {
        delegate?.contentableViewControllerCloseTapped(self)
    }
    
    @objc open func viewDimmedTapped() {
        delegate?.contentableViewControllerViewDimmedTapped(self)
    }
    
}


// MARK: - UIGestureRecognizerDelegate

extension ContentableViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return gestureRecognizer.view === touch.view
    }
}

extension ContentableViewController {
    static func getView(for backgroundStyle: ContentableViewAppearance.BackgroundStyle) -> UIView {
        switch backgroundStyle {
        case .blur(let style):
            return UIVisualEffectView(effect: UIBlurEffect(style: style))
        case .color(let color):
            let v = UIView()
            v.backgroundColor = color
            return v
        }
    }
}
