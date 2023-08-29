//
//  File.swift
//  
//
//  Created by Roi Mulia on 30/11/2020.
//

import UIKit


open class StyledNavigationController: UINavigationController {
    
    open override var prefersStatusBarHidden: Bool { return appeareance.isStatusBarHidden }
    open override var preferredStatusBarStyle: UIStatusBarStyle { return appeareance.statusBarStyle }

    let appeareance: SNCAppeareance

    public enum SNCStyle {
        case smoothBlur(UIColor)
        case solidColor(UIColor)
        
        var color: UIColor {
            switch self {
            case .solidColor(let color), .smoothBlur(let color):
                return color
            }
        }
    }
    
    public struct SNCAppeareance {
        let style: SNCStyle
        let isStatusBarHidden: Bool
        let statusBarStyle: UIStatusBarStyle
        
        public init(style: SNCStyle, isStatusBarHidden: Bool = true, statusBarStyle: UIStatusBarStyle = .default) {
            self.style = style
            self.isStatusBarHidden = isStatusBarHidden
            self.statusBarStyle = statusBarStyle
        }
    }
    
    
    public init(appeareance: SNCAppeareance) {
        self.appeareance = appeareance
        super.init(nibName: nil, bundle: nil)
    }
    
    public init(rootViewController: UIViewController, appeareance: SNCAppeareance) {
        self.appeareance = appeareance
        super.init(nibName: nil, bundle: nil)
        viewControllers = [rootViewController]
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.appeareance = .init(style: .smoothBlur(.white))
        super.init(coder: aDecoder)
    }
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        updateStyle()
    }
    
    public func updateStyle() {
        switch appeareance.style {
        case .smoothBlur(let color):
            setSmoothBlurStyle(with: color)
        case .solidColor(let color):
            setSolidColorStyle(with: color)
        }
    }
    
    private func setSmoothBlurStyle(with color: UIColor) {
        
        let blurEffect: UIBlurEffect.Style
        
        if  #available(iOS 15.0, *) {
            blurEffect = appeareance.style.color.luminance > 0.5 ? .light : .dark
        } else {
            blurEffect = .regular
        }
            
        view.backgroundColor = color
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithDefaultBackground()
        navBarAppearance.backgroundEffect = .init(style: blurEffect)
        navBarAppearance.shadowColor = .clear
        navBarAppearance.shadowImage = UIImage()
        navBarAppearance.backgroundColor = color.withAlphaComponent(0.4)
        navigationBar.standardAppearance = navBarAppearance
        navigationBar.compactAppearance = navBarAppearance
        navigationBar.scrollEdgeAppearance = navBarAppearance
        if #available(iOS 15.0, *) {
            navigationBar.compactScrollEdgeAppearance = navBarAppearance
        }
        let navigationBarAppearance = navigationBar
        navigationBarAppearance.setBackgroundImage(UIImage(), for: .default)
    }
    
    private func setSolidColorStyle(with color: UIColor) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = color
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        view.backgroundColor = color
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        if #available(iOS 15.0, *) {
            navigationBar.compactScrollEdgeAppearance = appearance
        }
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateStyle()
    }
}
