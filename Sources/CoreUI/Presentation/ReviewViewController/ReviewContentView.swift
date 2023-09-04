
import UIKit

class ReviewContentView: UIView, ContentableView {
 
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var ctaButton: ShimmerButton!
    @IBOutlet weak var starsView: FiveStarsView!
    var ctaButtonTappedClosure: (() -> Void)?
  
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        subtitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        ctaButton.titleLabel?.font = UIFont.roundedFont(size: 20, weight: .semibold)
    }
    

    func configureWithColorScheme(_ colorScheme: ColorScheme) {
        titleLabel.textColor = colorScheme.title
        subtitleLabel.textColor = colorScheme.subtitle
        ctaButton.backgroundGradient = colorScheme.gradient
        ctaButton.backgroundColor = .clear
        ctaButton.titleGradient = .solid(colorScheme.ctaForeground)
        starsView.backgroundColor = .clear
    }
    


    @IBAction func ctaTapped(_ sender: Any) {
        ctaButtonTappedClosure?()
    }
    
    func postAppearanceActions() {
        ctaButton.setNeedsDisplay()
        ctaButton.layoutIfNeeded()
    }
    

}
