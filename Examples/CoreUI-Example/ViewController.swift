//
//  ViewController.swift
//  shimmerTest
//
//  Created by Anton Kormakov on 15.12.2020.
//

import UIKit
import CoreUI

class ViewController: UIViewController {

    let colorScheme = ColorScheme(
      active: UIColor(named: "active")!,
      title: UIColor(named: "title")!,
      subtitle:  UIColor(named: "subtitle")!,
      notActive: UIColor(named: "notActive")!,
      background: UIColor(named: "background")!,
      foreground: UIColor(named: "foreground")!,
      disabled: UIColor(named: "disabled")!,
      ctaForeground: .white,
      gradient:  Gradient(direction: .horizontal, colors: [UIColor(hex: "#3C36FF"), UIColor(hex: "#514BF1")])
      )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let shimmerButton = ShimmerButton()
        shimmerButton.setTitle("Wow", for: .normal)
        shimmerButton.titleGradient = .solid(.white)
        shimmerButton.frame.size = .init(width: 300, height: 55)
        shimmerButton.center = view.center
        view.addSubview(shimmerButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //showReviewDialog()
        showSheet()
    }
    
    
    func showReviewDialog() {
        let reviewViewController = ReviewViewController(colorScheme: colorScheme)
        present(reviewViewController, animated: true)
        reviewViewController.didReviewApp = {
            print("did review app")
        }
    }
    
    func showSheet() {
        let error = SheetInfoViewController(image: UIImage(systemName: "xmark"), title: "wow", subtitle: nil, colorScheme: colorScheme)
        
        let sheetViewController = SheetViewController(content: error)
        
        present(sheetViewController, animated: true)
    }
  
}
