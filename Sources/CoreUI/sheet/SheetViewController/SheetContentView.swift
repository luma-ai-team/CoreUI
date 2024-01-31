//
//  SheetContentView.swift
//  SheetTest
//
//  Created by Anton Kormakov on 08.01.2024.
//

import UIKit

public  protocol SheetContentHeightProvider {
    @available(iOS 16.0, *)
    var heightResolver: (UISheetPresentationControllerDetentResolutionContext) -> CGFloat { get }
}

public protocol SheetContent: AnyObject, SheetContentHeightProvider {
    var isModal: Bool { get }
    var view: UIView! { get }
}

extension UIView: SheetContentHeightProvider {
    @available(iOS 16.0, *)
    public var heightResolver: (UISheetPresentationControllerDetentResolutionContext) -> CGFloat {
        return { _ -> CGFloat in
            return self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        }
    }
}

extension UIViewController: SheetContent {
    public var isModal: Bool {
        return isModalInPresentation
    }

    @available(iOS 16.0, *)
    public var heightResolver: (UISheetPresentationControllerDetentResolutionContext) -> CGFloat {
        return view.heightResolver
    }
}
