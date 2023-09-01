//
//  ReviewContentView.swift
//  
//
//  Created by Roi Mulia on 17/01/2023.
//

import UIKit


protocol ReviewContentViewDelegate: AnyObject {
    func reviewContentViewCtaTapped(_ reviewContentView: ReviewContentView)
}

class ReviewContentView: UIView, ContentableView {
 
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var ctaButton: ShimmerButton!
    @IBOutlet weak var starsView: FiveStarsView!
    
    weak var delegate: ReviewContentViewDelegate?
    
        
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
        delegate?.reviewContentViewCtaTapped(self)
    }
    
    func postAppearanceActions() {
        ctaButton.setNeedsDisplay()
        ctaButton.layoutIfNeeded()
    }
    

}
