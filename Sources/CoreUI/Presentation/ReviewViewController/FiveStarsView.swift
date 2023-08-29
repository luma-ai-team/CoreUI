//
//  File.swift
//  
//
//  Created by Eilon Krauthammer on 17/01/2021.
//

import UIKit

open class FiveStarsView: UIView {

    private let gradientView = GradientView()
    private let stackView = UIStackView()

    public var gradient: Gradient = .solid(.systemPink) {
        didSet {
            gradientView.gradient = gradient
        }
    }
    
    public var gap: CGFloat = 5.0 {
        didSet {
            setNeedsDisplay()
            layoutIfNeeded()
        }
    }
    public var shouldAnimateStars = true {
        didSet {
            setNeedsDisplay()
            layoutIfNeeded()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        gradientView.gradient = gradient
        addSubview(gradientView)
        gradientView.bindMarginsToSuperview()
        
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.backgroundColor = .clear
        for _ in 0...4 {
            let crispStar = UIImage(named: "star", in: .module, compatibleWith: nil)
            let imageView = UIImageView(image: crispStar)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.backgroundColor = .clear
            imageView.contentMode = .scaleAspectFit
            stackView.addArrangedSubview(imageView)
        }
        addSubview(stackView)
        stackView.bindMarginsToSuperview()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        for v in stackView.arrangedSubviews {
            v.layer.removeAllAnimations()
            let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
            scaleAnimation.values = [1, 1.1, 0.9, 1, 1];
            scaleAnimation.keyTimes = [0, 0.1, 0.2, 0.3, 1];
            scaleAnimation.duration = 2;
            scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            scaleAnimation.repeatCount = Float.infinity
            scaleAnimation.beginTime = CFTimeInterval(Float.random(in: 0.2...0.6))
            v.layer.add(scaleAnimation, forKey: nil)
        }
        gradientView.frame = bounds
        gradientView.mask = stackView
    }

}
