//
//  SharingSuccessSheetContent.swift
//
//  Created by Anton Kormakov on 05.02.2024.
//

import UIKit
import Lottie

public protocol SharingSuccessSheetContentDelegate: AnyObject {
    func sharingSuccessSheetContentDidRequestAppReview(_ sender: SharingSuccessSheetContent)
}

public final class SharingSuccessSheetContent: DismissableSheetContentViewController {

    weak var delegate: SharingSuccessSheetContentDelegate?

    public lazy var successImage: UIImage = {
        let colorConfiguration = UIImage.SymbolConfiguration(paletteColors: [colorScheme.background, colorScheme.title])
        let fontConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        let symbolConfiguration = fontConfiguration.applying(colorConfiguration)
        return UIImage(systemName: "checkmark.circle.fill", withConfiguration: symbolConfiguration) ?? .init()
    }()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    @IBOutlet weak var appReviewView: UIView!
    @IBOutlet weak var reviewContainerView: UIView!
    @IBOutlet weak var reviewTitleLabel: UILabel!
    @IBOutlet weak var reviewSubtitleLabel: UILabel!
    
    @IBOutlet weak var starsView: LottieAnimationView!

    private lazy var tapGestureRecoginzer: UITapGestureRecognizer = .init(target: self,
                                                                          action: #selector(viewTapped))

    private let shouldAskForAppReview: Bool

    public init(colorScheme: ColorScheme, title: String, shouldAskForAppReview: Bool) {
        self.shouldAskForAppReview = shouldAskForAppReview
        super.init(colorScheme: colorScheme)
        self.title = title
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.textColor = colorScheme.title
        titleLabel.text = title

        subtitleLabel.textColor = colorScheme.subtitle
        imageView.tintColor = colorScheme.active

        appReviewView.isHidden = shouldAskForAppReview == false
        reviewTitleLabel.textColor = colorScheme.title
        reviewSubtitleLabel.textColor = colorScheme.subtitle

        starsView.animation = LottieAnimation.asset("lottie-stars-anim", bundle: .module)
        starsView.contentMode = .scaleAspectFill
        starsView.play()

        reviewContainerView.backgroundColor = colorScheme.background
        reviewContainerView.roundCorners(to: .custom(10.0))
        reviewContainerView.addGestureRecognizer(tapGestureRecoginzer)
    }

    @objc private func viewTapped() {
        delegate?.sharingSuccessSheetContentDidRequestAppReview(self)
    }
}
