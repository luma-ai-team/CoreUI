//
//  ProgressSheetContent.swift
//
//  Created by Anton Kormakov on 02.02.2024.
//

import UIKit

public final class ProgressSheetContent: DismissableSheetContentViewController {

    public enum State {
        case progress(String, Float)
        case failure(Error)
        case success(String)
        case custom(UIImage?, String, String?)
    }

    public var state: State {
        didSet {
            updateState()
        }
    }

    public lazy var errorImage: UIImage = {
        let colorConfiguration = UIImage.SymbolConfiguration(paletteColors: [colorScheme.background, colorScheme.title])
        let fontConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        let symbolConfiguration = fontConfiguration.applying(colorConfiguration)
        return UIImage(systemName: "xmark.circle.fill", withConfiguration: symbolConfiguration) ?? .init()
    }()

    public lazy var successImage: UIImage = {
        let colorConfiguration = UIImage.SymbolConfiguration(paletteColors: [colorScheme.background, colorScheme.title])
        let fontConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        let symbolConfiguration = fontConfiguration.applying(colorConfiguration)
        return UIImage(systemName: "checkmark.circle.fill", withConfiguration: symbolConfiguration) ?? .init()
    }()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressContainerView: UIView!

    public init(colorScheme: ColorScheme, state: State = .progress(.init(), 0.0)) {
        self.state = state
        super.init(colorScheme: colorScheme)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        progressView.tintColor = colorScheme.active
        progressView.trackTintColor = colorScheme.notActive
        progressView.progressTintColor = colorScheme.active
        progressView.clipsToBounds = true

        titleLabel.textColor = colorScheme.title
        subtitleLabel.textColor = colorScheme.subtitle
        imageView.tintColor = colorScheme.active

        updateState()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        progressView.layer.cornerRadius = progressView.bounds.midY
    }

    private func updateState() {
        switch state {
        case .progress(let title, let progress):
            progressContainerView.setHidden(false, animated: false)
            progressView.setProgress(progress, animated: true)
            update(title: title)
            isModalInPresentation = true
        case .failure(let error):
            progressContainerView.setHidden(true, animated: false)
            update(with: errorImage, title: "Error", subtitle: error.localizedDescription)
            isModalInPresentation = false
        case .success(let message):
            progressContainerView.setHidden(true, animated: false)
            update(with: successImage, title: message)
            isModalInPresentation = false
        case .custom(let image, let title, let subtitle):
            progressContainerView.setHidden(true, animated: false)
            update(with: image, title: title, subtitle: subtitle)
            isModalInPresentation = false
        }
    }

    private func update(with image: UIImage? = nil, title: String, subtitle: String? = nil) {
        imageView.setHidden(image == nil, animated: false)
        imageView.image = image

        titleLabel.text = title
        subtitleLabel.text = subtitle
        subtitleLabel.setHidden(subtitle == nil, animated: false)
    }
}
