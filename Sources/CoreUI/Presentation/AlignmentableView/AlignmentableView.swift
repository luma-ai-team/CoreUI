//
//  AlignmenButton.swift
//  TestProject
//
//  Created by Roi Mulia on 20/09/2020.
//  Copyright © 2020 Roi Mulia. All rights reserved.
//

import Foundation
import UIKit

public  enum AligmentablePosition {
    case left
    case right
    case natural
}

public  protocol AlignmentableView {
    var alignmentableImagePosition: AligmentablePosition { get set }
    var alignmentableTitlePosition: AligmentablePosition { get set }
    var alignmentPadding: CGFloat { get set }
    func updateAlignment()
}



