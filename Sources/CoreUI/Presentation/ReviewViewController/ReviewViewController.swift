
import UIKit


public protocol ReviewControllerOutput: AnyObject {
    func reviewViewControllerCtaTapped(_ reviewViewController: ReviewViewController)
}

open class ReviewViewController: PopupViewController {
    
    // MARK: - Outlets
    public weak var output: ReviewControllerOutput?
    
    let reviewContentView: ReviewContentView
    
    public init
    (title: String = "Save for FREE",
     subtitle: String = "Review us 5 stars on the App Store, and save for free!",
     ctaTitle: String = "Review 5 Stars to Save",
     colorScheme: ColorScheme) {
        let reviewContentView: ReviewContentView = UIView.fromNib(bundle: .module)
        reviewContentView.titleLabel.text = title
        reviewContentView.subtitleLabel.text = subtitle
        reviewContentView.ctaButton.setTitle(ctaTitle, for: .normal)
        reviewContentView.configureWithColorScheme(colorScheme)
        self.reviewContentView = reviewContentView
        let appearance = ContentableViewAppearance(
            backgroundColor: colorScheme.foreground,
            closeTintColor: colorScheme.subtitle,
            closeImage: nil,
            viewBackgroundStyle: .color(.black.withAlphaComponent(0.7)))
        super.init(initWith: reviewContentView, appearance: appearance)
        reviewContentView.delegate = self
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func closeTapped() {
        dismiss(animated: true)
    }
    
    open override func viewDimmedTapped() {
        dismiss(animated: true)
    }
}


extension ReviewViewController: ReviewContentViewDelegate {
    func reviewContentViewCtaTapped(_ reviewContentView: ReviewContentView) {
        output?.reviewViewControllerCtaTapped(self)
    }
}
