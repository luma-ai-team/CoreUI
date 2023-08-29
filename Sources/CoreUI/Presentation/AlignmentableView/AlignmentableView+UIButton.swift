//
//  AlignmentableView+UIButton.swift
//  TestProject
//
//  Created by Roi Mulia on 21/09/2020.
//  Copyright © 2020 Roi Mulia. All rights reserved.
//

import UIKit


public  extension AlignmentableView where Self: UIButton {
    func updateAlignment() {
        switch alignmentableImagePosition {
        case .right:
            imageView?.frame.origin.x = bounds.width - (currentImage?.size.width ?? 0) - alignmentPadding
        case .left:
            imageView?.frame.origin.x = alignmentPadding
        case .natural:
            break
        }
        
        switch alignmentableTitlePosition {
        case .right:
            titleLabel?.frame.origin.x = bounds.width - (titleLabel?.frame.size.width ?? 0) - alignmentPadding
        case .left:
            titleLabel?.frame.origin.x = alignmentPadding   
        case .natural:
            break
            //contentHorizontalAlignment = .center
        }
    }
}
