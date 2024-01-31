//
//  WowViewController.swift
//  Popup
//
//  Created by Nir Endy on 01/01/2024.
//

import UIKit
import CoreUI

class FetchViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    var colorScheme: ColorScheme?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let colorScheme = colorScheme {
            titleLabel.textColor = colorScheme.title
            progressView.progressTintColor = colorScheme.title
            progressView.trackTintColor = colorScheme.notActive
            view.backgroundColor = colorScheme.foreground
        }
        
        progressView.progress = 0
        // Do any additional setup after loading the view.
    }
    
    
    func setProgress(progress: Float) {
        progressView.setProgress(progress, animated: true)
    }


}

class GradientButton2: UIButton {
    private var gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureGradient()
        observeTintColorChanges()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureGradient()
        observeTintColorChanges()
    }

    private func configureGradient() {
        // Configure your gradient layer with initial colors
        gradientLayer.colors = [UIColor.systemRed.cgColor, UIColor.systemBlue.cgColor]
        layer.insertSublayer(gradientLayer, at: 0)
    }

    private func observeTintColorChanges() {
        // Observe for tint color changes
        addObserver(self, forKeyPath: "tintColor", options: .new, context: nil)
    }

    deinit {
        // Remove observer when the button is deinitialized
        removeObserver(self, forKeyPath: "tintColor")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "tintColor" {
            // Respond to tint color change
            updateGradientWithTintColor()
        }
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        updateGradientWithTintColor()
    }

    private func updateGradientWithTintColor() {
        // Adjust your gradient colors based on the new tint color
        // This is a simplistic example, you might want to calculate light/dark versions of the tint color
        if let tintColor = tintColor {
            gradientLayer.colors = [tintColor.withAlphaComponent(0.5).cgColor, tintColor.cgColor]
        }
    }
}
