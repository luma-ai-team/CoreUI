//
//  BorderStackView.swift
//  AlertTryout
//
//  Created by Roi Mulia on 26/01/2023.
//

import UIKit



class AlertContentView: UIView, ContentableView, ForceViewUpdate {
    
    @IBOutlet weak var visualAidContainer: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var titlesStackView: UIStackView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buttonsStackView: BorderStackView!

    var viewModel: AlertViewModel = .init(visualAid: .none, appearance: .default)

    func update(with viewModel: AlertViewModel, animated: Bool, force: Bool = false) {
        let oldViewModel = self.viewModel
        self.viewModel = viewModel

        let appearance = viewModel.appearance
        guard animated else {
            updateLabels(with: viewModel)
            updateAidView(with: viewModel.visualAid, appearance: appearance, animated: animated)
            updateButtons(with: viewModel.actionsInfo, appearance: appearance)
            return
        }

        var animatedViews: [UIView] = []
        if titleLabel.text != viewModel.title {
            animatedViews.append(titleLabel)
        }
        if subtitleLabel.text != viewModel.subtitle {
            animatedViews.append(subtitleLabel)
        }

        switch (viewModel.visualAid, oldViewModel.visualAid) {
        case (.spinner, .spinner), (.image, .image), (.progress, .progress), (.none, .none):
            break
        default:
            animatedViews.append(visualAidContainer)
        }

        let actions = viewModel.actionsInfo?.actions ?? []
        if actions.count != buttonsStackView.arrangedSubviews.count {
            animatedViews.append(buttonsStackView)
        }
        else {
            for (action, button) in zip(actions, buttonsStackView.arrangedSubviews) {
                guard action.title != (button as? UIButton)?.title(for: .normal) else {
                    continue
                }
                animatedViews.append(buttonsStackView)
                break
            }
        }

        performUpdateAnimation(for: animatedViews) { [weak self] in
            self?.updateLabels(with: viewModel)
            self?.updateAidView(with: viewModel.visualAid, appearance: appearance, animated: animated)
            self?.updateButtons(with: viewModel.actionsInfo, appearance: appearance)
        }
    }

    private func updateButtons(with actionsInfo: AlertActionsInfo?, appearance: AlertAppearance) {
        guard let actionsInfo = actionsInfo,
              actionsInfo.actions.isEmpty == false else {
            bottomConstraint.constant = 20
            buttonsStackView.isHiddenInStackView = true
            return
        }

        var buttons: [UIButton] = []
        var existingButtonIterator = buttonsStackView.arrangedSubviews.makeIterator()
        buttonsStackView.axis = actionsInfo.buttonAxis
        buttonsStackView.isHiddenInStackView = false
        for i in 0...actionsInfo.actions.count - 1  {
            let action = actionsInfo.actions[i]
            let button = (existingButtonIterator.next() as? UIButton) ?? UIButton(type: .system)
            button.setTitle(action.title, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = i 
            button.heightAnchor.constraint(equalToConstant: 44).isActive = true
            button.setImage(action.image, for: .normal)

            button.removeTarget(self, action: nil, for: .touchUpInside)
            button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)

            let font: UIFont
            let color: UIColor
            switch action.style {
            case .default:
                font = UIFont.systemFont(ofSize: 17, weight: .regular)
                color = appearance.regularButtonColor
            case .cancel:
                font = UIFont.systemFont(ofSize: 17, weight: .semibold)
                color = appearance.regularButtonColor
            case .destructive:
                font = UIFont.systemFont(ofSize: 17, weight: .regular)
                color = appearance.destructiveButtonColor
            @unknown default:
                font = UIFont.systemFont(ofSize: 17, weight: .regular)
                color = appearance.regularButtonColor
            }
            button.setTitleColor(color, for: .normal)
            button.titleLabel?.font = font
            button.tintColor = color

            button.imageEdgeInsets.left = -2
            buttonsStackView.addArrangedSubview(button)
            buttons.append(button)
        }

        for oldButton in buttonsStackView.arrangedSubviews {
            if buttons.contains(where: { (button: UIButton) in
                return button === oldButton
            }) == false {
                oldButton.removeFromSuperview()
            }
        }

        bottomConstraint.constant = 0
    }

    private func updateAidView(with visualAid: AlertVisualAid, appearance: AlertAppearance, animated: Bool) {
        visualAidContainer.backgroundColor = .clear
        var aidView = visualAidContainer.subviews.last
        switch visualAid {
        case .customView(let view, let size):
            visualAidContainer.addSubview(view)
            if let size = size {
                view.widthAnchor.constraint(equalToConstant: size.width).isActive = true
                view.heightAnchor.constraint(equalToConstant: size.height).isActive = true
            }
            view.bindMarginsToSuperview()
            aidView = view
        case .image(let image):
            let imageView = (aidView as? UIImageView) ?? UIImageView()
            imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            imageView.image = image
            imageView.contentMode = .center
            imageView.backgroundColor = .clear
            visualAidContainer.addSubview(imageView)
            imageView.bindMarginsToSuperview()
            imageView.tintColor = appearance.titleColor
            visualAidContainer.isHiddenInStackView = image == nil
            aidView = imageView
        case .spinner:
            let indicator = (aidView as? UIActivityIndicatorView) ?? UIActivityIndicatorView(style: .large)
            indicator.color = appearance.titleColor
            indicator.tintColor = appearance.titleColor
            indicator.startAnimating()
            visualAidContainer.addSubview(indicator)
            indicator.bindMarginsToSuperview()
            visualAidContainer.isHiddenInStackView = false
            aidView = indicator
        case .progress(let progress):
            let view = (aidView as? CircularGradientProgressView) ?? CircularGradientProgressView()
            view.appearance = .init(emptyColor: appearance.titleColor.withAlphaComponent(0.25),
                                    fillGradient: .solid(appearance.titleColor),
                                    lineWidth: 6.0)
            view.widthAnchor.constraint(equalToConstant: 30).isActive = true
            view.heightAnchor.constraint(equalToConstant: 30).isActive = true
            view.setProgress(progress: progress, animation: animated ? .basic(duration: 0.1) : .none)
            visualAidContainer.addSubview(view)
            view.bindMarginsToSuperview()
            visualAidContainer.isHiddenInStackView = false
            aidView = view
        case .none:
            visualAidContainer.isHiddenInStackView = true
            aidView = nil
        }

        for oldAidView in visualAidContainer.subviews where oldAidView !== aidView {
            oldAidView.removeFromSuperview()
        }
    }

    private func updateLabels(with viewModel: AlertViewModel) {
        let appearance = viewModel.appearance
        if let title = viewModel.title {
            titleLabel.textColor = appearance.titleColor
            titleLabel.text = title
            titleLabel.isHiddenInStackView = false
        } else {
            titleLabel.isHiddenInStackView = true
        }

        if let subtitle = viewModel.subtitle {
            subtitleLabel.textColor = appearance.subtitleColor
            subtitleLabel.text = subtitle
            subtitleLabel.isHiddenInStackView = false
        } else {
            subtitleLabel.isHiddenInStackView = true
        }
    }

    private func performUpdateAnimation(for views: [UIView], updateHandler: @escaping () -> Void) {
        UIView.animate(withDuration: 0.2) {
            for view in views {
                view.alpha = 0.0
            }
        } completion: { _ in
            updateHandler()
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
            } completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    for view in views {
                        view.alpha = 1.0
                    }
                }
            }
        }
    }

    @objc private func buttonPressed(_ sender: UIButton) {
        Haptic.selection.generate()
        if let action = viewModel.actionsInfo?.actions[safe: sender.tag] {
            action.handler()
        }
    }

    func postAppearanceActions() {
        //
    }
}
