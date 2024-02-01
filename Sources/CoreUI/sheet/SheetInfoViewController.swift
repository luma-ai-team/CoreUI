//
//  ErrorViewController.swift
//  white-teeth
//
//  Created by Nir Endy on 09/01/2024.
//

import UIKit

#warning("TODO: BaseSheetContentViewController")
open class SheetInfoViewController: UIViewController  {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    private let colorScheme: ColorScheme
    private let image: UIImage?
    private let titleText: String?
    private let subtitleText: String?
    
    public init(
        image: UIImage? = nil,
        title: String? = nil,
        subtitle: String? = nil,
        colorScheme: ColorScheme) {
        self.image = image
        self.titleText = title
        self.subtitleText = subtitle
        self.colorScheme = colorScheme
        super.init(nibName: nil, bundle: .module) // Change .module to nil if you're not using Swift Package Manager
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        // Hide imageView if image is nil
        imageView.isHidden = image == nil
        if let image = image {
            imageView.image = image
        }
        
        // Hide titleLabel if titleText is nil
        titleLabel.isHidden = titleText == nil
        titleLabel.text = titleText
        
        // Hide subtitleLabel if subtitleText is nil
        subtitleLabel.isHidden = subtitleText == nil
        subtitleLabel.text = subtitleText
        
        imageView.tintColor = colorScheme.title
        titleLabel.textColor = colorScheme.title
        subtitleLabel.textColor = colorScheme.subtitle
        view.backgroundColor = colorScheme.foreground
    }

    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        onDismiss?()
    }

}
