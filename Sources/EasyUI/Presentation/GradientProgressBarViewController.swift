//
//  File.swift
//  
//
//  Created by Roi Mulia on 05/02/2023.
//

import Foundation
import UIKit


open class GradientProgressBarViewController: UIViewController {
    
    open override var prefersStatusBarHidden: Bool {
        return true 
    }
    
    public var progressBar = GradientProgressBar()
    
    public init(colorScheme: ColorScheme) {
        super.init(nibName: nil, bundle: .module)
        progressBar.progressGradient = colorScheme.gradient
        progressBar.backgroundColor = colorScheme.foreground
    }
    
    public init() {
        super.init(nibName: nil, bundle: .module)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(progressBar)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        let dynamicWidthConstraint = progressBar.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100)
        dynamicWidthConstraint.priority = .init(rawValue: 999)
        NSLayoutConstraint.activate([
            progressBar.widthAnchor.constraint(lessThanOrEqualToConstant: 400),
            dynamicWidthConstraint,
            progressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressBar.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 8)
        ])
    }
    
    
}
