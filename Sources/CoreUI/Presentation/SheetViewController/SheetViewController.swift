//
//  SheetViewController.swift
//  SheetTest
//
//  Created by Anton Kormakov on 08.01.2024.
//

import UIKit

open class SheetViewController: UIViewController {

    public private(set) var content: any SheetContent
    public var dismissHandler: (() -> Void)?

    private var sheet: UISheetPresentationController {
        if let sheetPresentationController = sheetPresentationController {
            return sheetPresentationController
        }

        assertionFailure("Misconfigured modalPresentationStyle for \(self)")
        return UISheetPresentationController(presentedViewController: self, presenting: nil)
    }

    open override var modalPresentationStyle: UIModalPresentationStyle {
        set {}
        get {
            return .formSheet
        }
    }

    public init(content: any SheetContent) {
        self.content = content
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        super.modalPresentationStyle = .formSheet
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true

        update(with: content)
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateGestureRecognizers()
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBeingDismissed {
            dismissHandler?()
        }
    }

    private func updateGestureRecognizers() {
        guard let recognizers = presentationController?.presentedView?.gestureRecognizers else {
            return
        }

        for recognizer in recognizers {
            recognizer.isEnabled = content.isModal == false
        }
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        content.view.frame = view.bounds
    }

    open override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        content.view.frame = .zero
        content.view.frame = view.bounds
        
        DispatchQueue.main.async {
            self.updateContent()
        }
    }

    open func update(with content: any SheetContent) {
        if self.content !== content {
            content.view.frame = self.content.view.frame
            self.content.view.removeFromSuperview()
        }

        self.content = content
        if let dismissableContent = content as? DismissableSheetContent {
            dismissableContent.dismissHandler = dismiss
        }

        view.addSubview(content.view)
        view.backgroundColor = content.view.backgroundColor
        content.view.layoutIfNeeded()

        updateContent()
    }

    open func updateContent() {
        isModalInPresentation = content.isModal
        if #available(iOS 16.0, *) {
            sheet.detents = [.custom(resolver: content.heightResolver)]
        } else {
            sheet.detents = [.medium()]
        }

        updateGestureRecognizers()
        if #available(iOS 16.0, *) {
            sheet.animateChanges {
                sheet.invalidateDetents()
            }
        }
    }

    open func dismiss() {
        dismiss(animated: true)
    }
}
