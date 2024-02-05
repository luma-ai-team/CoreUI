//
//  ViewController.swift
//  shimmerTest
//
//  Created by Anton Kormakov on 15.12.2020.
//

import UIKit
import CoreUI
import AVFoundation

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

    private lazy var pickerCoordinator: SystemPickerCoordinator = .init(rootViewController: self, colorScheme: colorScheme)
    private lazy var shareCoordinator: ShareCoordinator = .init(rootViewController: self,
                                                                colorScheme: colorScheme,
                                                                contentDescription: "Banana")

    override func viewDidLoad() {
        super.viewDidLoad()
        let shimmerButton = ShimmerButton()
        shimmerButton.setTitle("Wow", for: .normal)
        shimmerButton.titleGradient = .solid(.white)
        shimmerButton.frame.size = .init(width: 300, height: 55)
        shimmerButton.addAction(.init(handler: { _ in
            self.showShare()
        }), for: .touchUpInside)
        shimmerButton.center = view.center
        view.addSubview(shimmerButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //showReviewDialog()
        //showPicker()
        showShare()
    }
    
    
    func showReviewDialog() {
        let reviewViewController = ReviewViewController(colorScheme: colorScheme)
        present(reviewViewController, animated: true)
        reviewViewController.didReviewApp = {
            print("did review app")
        }
    }
  
    func showPicker() {
        pickerCoordinator.shouldTreatLivePhotosAsVideos = false
        pickerCoordinator.output = self
        pickerCoordinator.start()
    }

    func showShare() {
        shareCoordinator.output = self
        shareCoordinator.start()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.shareCoordinator.show(progress: 0.5)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.shareCoordinator.show(progress: 1.0)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.shareCoordinator.save(.init(named: "Test") ?? .init())
        }
    }
}

// MARK: - PickerCoordinatorOutput

extension ViewController: PickerCoordinatorOutput {
    func systemPickerCoordinatorDidCancel(_ coordinator: SystemPickerCoordinator) {
        //
    }

    func systemPickerCoordinatorDidSelect(_ coordinator: SystemPickerCoordinator, asset: AVAsset) {
        //
    }

    func systemPickerCoordinatorDidSelect(_ coordinator: SystemPickerCoordinator, image: UIImage) {
        print(image)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            let colorConfiguration = UIImage.SymbolConfiguration(paletteColors: [colorScheme.background, colorScheme.title])
            let fontConfiguration = UIImage.SymbolConfiguration(pointSize: 48, weight: .medium)
            let symbolConfiguration = fontConfiguration.applying(colorConfiguration)
            let image = UIImage(systemName: "person.crop.circle.badge.exclamationmark", withConfiguration: symbolConfiguration)
            coordinator.show(image: image,
                             title: "No Face Detected",
                             subtitle: "Please select and image with a face.")
        }
    }
}

// MARK: - ShareCoordinatorOutput

extension ViewController: ShareCoordinatorOutput {
    func shareCoordinatorDidCancel(_ coordinator: ShareCoordinator) {
        print("cancel")
    }

    func shareCoordinatorDidSave(_ coordinator: ShareCoordinator, assetIdentifier: String) {
        print(assetIdentifier)
    }
}
