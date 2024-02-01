//
//  LoadingViewController.swift
//  new-ai-profile-picture
//
//  Created by Nir Endy on 24/01/2024.
//

import UIKit

class PickerLoadingViewController: UIViewController {

    private var loadingIndicator: UIActivityIndicatorView!
    private var titleLabel: UILabel!
    private var visualEffectView: UIVisualEffectView!
    private let colorScheme: ColorScheme
    
    init(colorScheme: ColorScheme) {
        self.colorScheme = colorScheme
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        // Create and add the visual effect view
        let effect = UIBlurEffect(style: .systemMaterial)
        visualEffectView = UIVisualEffectView(effect: effect)
        visualEffectView.frame = self.view.bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(visualEffectView)

        // Create and add the loading indicator
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.color = .label // System color that adapts to light/dark mode
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(loadingIndicator)

        // Create and add the label
        titleLabel = UILabel()
        titleLabel.text = "Loading"
        titleLabel.textColor = .label // System color that adapts to light/dark mode
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(titleLabel)

        // Setup constraints for the loading indicator and label
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),

            titleLabel.topAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])

        // Start animating the loading indicator
        loadingIndicator.startAnimating()
    }
}

