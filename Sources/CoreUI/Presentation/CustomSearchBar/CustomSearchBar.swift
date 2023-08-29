//
//  File.swift
//  
//
//  Created by Roi Mulia on 31/10/2022.
//

import UIKit


open class CustomSearchBar: UISearchBar {
    
    public struct CustomSearchBarAppearance {
        let backgroundColor: UIColor
        let placeholderColor: UIColor
        let textColor: UIColor
        let placeholderText: String
        let placeholderFont: UIFont?
        
        public init(backgroundColor: UIColor, placeholderColor: UIColor, textColor: UIColor, placeholderText: String, placeholderFont: UIFont?) {
            self.backgroundColor = backgroundColor
            self.placeholderColor = placeholderColor
            self.textColor = textColor
            self.placeholderText = placeholderText
            self.placeholderFont = placeholderFont
        }
        
    }
    
    let appearance: CustomSearchBarAppearance

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public init(appearance: CustomSearchBarAppearance = .init(
        backgroundColor: .red,
        placeholderColor: .blue,
        textColor: .green,
        placeholderText: "change me",
        placeholderFont: nil
    )
    ) {
        self.appearance = appearance
        super.init(frame: .zero)
        
        searchTextField.clearButtonMode = .always
        isTranslucent = false
        
        let backgroundColor =  appearance.backgroundColor
        let placeholderColor = appearance.placeholderColor
        let textColor = appearance.textColor
        
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: appearance.placeholderText,
            attributes: [.foregroundColor: placeholderColor]
        )
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = placeholderColor
        
        directionalLayoutMargins = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        searchBarStyle = .default
        barStyle = .default
        searchTextField.textColor = textColor
        searchTextField.backgroundColor = backgroundColor
        searchTextField.tintColor = textColor
        self.backgroundColor = .clear
        searchTextField.leftView?.tintColor = placeholderColor
        searchTextField.rightView?.tintColor = placeholderColor
        tintColor = placeholderColor
        backgroundImage = UIImage()
        barTintColor = UIColor.yellow
        hideBackgroundImageView()
        returnKeyType = .search
    }
}

private extension UISearchBar {
    func hideBackgroundImageView(){
        if let view:UIView = self.subviews.first {
            for curr in view.subviews {
                guard let searchBarBackgroundClass = NSClassFromString("UISearchBarBackground") else {
                    return
                }
                if curr.isKind(of:searchBarBackgroundClass){
                    if let imageView = curr as? UIImageView{
                        imageView.alpha = 0
                        break
                    }
                }
            }
        }
    }
}
