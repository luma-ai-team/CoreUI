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
    
    
    var configuration: ReviewViewController.Configuration?
    
    static func create(with configuration: ReviewViewController.Configuration) -> ReviewContentView {
        let contentView: ReviewContentView = UIView.fromNib(bundle: .module)
        contentView.configuration = configuration
        return contentView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configure()
    }
    
    private func configure() {
        guard let configuration = configuration else {
            return
        }
        
        titleLabel.text = configuration.title
        titleLabel.textColor = configuration.appearance.titleColor
        titleLabel.font = configuration.appearance.titleFont
        subtitleLabel.text = configuration.subtitle
        subtitleLabel.textColor = configuration.appearance.subtitleColor
        subtitleLabel.font = configuration.appearance.subtitleFont
        ctaButton.setTitle(configuration.ctaTitle, for: .normal)
        ctaButton.backgroundGradient = configuration.appearance.ctaBackgroundGradient
        ctaButton.backgroundColor = .clear
        ctaButton.layer.shadowOpacity = 0
        ctaButton.setTitleColor(configuration.appearance.ctaTextColor, for: .normal)
        starsView.gradient = configuration.appearance.starsGradient
        starsView.backgroundColor = .clear
        
        ctaButton.applyBounceAnimation(style: .medium)
    }

    @IBAction func ctaTapped(_ sender: Any) {
        delegate?.reviewContentViewCtaTapped(self)
    }
    
    func postAppearanceActions() {
        
    }
    

}
