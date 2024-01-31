import UIKit
import AVFoundation
import PhotosUI
import Vision

protocol PickerCoordinatorOutput: AnyObject {
    func systemPickerCoordinator(_ sender: SystemPickerCoordinator, selectedImage image: UIImage, sheetViewController: SheetViewController)
    func systemPickerCoordinator(_ sender: SystemPickerCoordinator, selectedVideo video: AVAsset, sheetViewController: SheetViewController)
   // func systemPickerCoordinatorWantsDismiss(_ sender: SystemPickerCoordinator)
}

final class SystemPickerCoordinator: BaseCoordinator<UIViewController> {
    
    let fetchService = MediaFetchService()
    let loadingViewController: PickerLoadingViewController
    let colorScheme: ColorScheme
    lazy var config: PHPickerConfiguration = {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.preferredAssetRepresentationMode = .current
        if #available(iOS 17.0, *) {
            config.disabledCapabilities = [.sensitivityAnalysisIntervention]
        }
        return config
    }()
    weak var output: PickerCoordinatorOutput?
    
    
    init(
        rootViewController: UIViewController,
        colorScheme: ColorScheme,
        filter: PHPickerFilter?)
    {
        loadingViewController = .init(colorScheme: colorScheme)
        self.colorScheme = colorScheme
        super.init(rootViewController: rootViewController)
        config.filter = filter
    }
    
    
    override func start() {
        loadingViewController.modalPresentationStyle = .fullScreen
        rootViewController.present(loadingViewController, animated: true)

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        picker.modalTransitionStyle = .crossDissolve
        picker.modalPresentationStyle = loadingViewController.modalPresentationStyle
        loadingViewController.present(picker, animated: true)
    }
    
    private func dismiss() {
        rootViewController.dismiss(animated: true)
        delegate?.childCoordinatorDidFinish(self)
    }

}

extension SystemPickerCoordinator: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard let result = results.first else {
            dismiss()
            return
        }
        
        let sheetDetailViewController = SheetInfoViewController(title: "Fetching", colorScheme: colorScheme)
        let sheetViewController =  SheetViewController(content: sheetDetailViewController)

        // Error, in case we need it
        
        sheetViewController.dismissHandler = { [weak self] in
            self?.fetchService.cancel()
        }
        
        picker.present(sheetViewController, animated: true)
        
        guard result.itemProvider.canLoadObject(ofClass: UIImage.self) else {
            dismiss()
            return
        }
        
        
        fetchService.fetchAsset(for: result) { progress in
            // progress
        } success: { [weak self] fetchedMedia in
            guard let self = self else { return }
            switch fetchedMedia {
            case .image(let image):
                self.output?.systemPickerCoordinator(self, selectedImage: image, sheetViewController: sheetViewController)
            case.video(let video):
                self.output?.systemPickerCoordinator(self, selectedVideo: video, sheetViewController: sheetViewController)
                
            }
        } failure: { [weak self] error in
            guard let self = self else { return }
            let errorViewController = SheetInfoViewController(title: "BAD ERROR!!", subtitle: "Please FixME", colorScheme: self.colorScheme)
            sheetViewController.update(with: errorViewController)
        }
    }
}
