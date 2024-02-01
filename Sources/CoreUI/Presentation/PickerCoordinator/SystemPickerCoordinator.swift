import UIKit
import AVFoundation
import PhotosUI
import Vision

// MARK: - Protocols

protocol PickerCoordinatorOutput: AnyObject {
    func systemPickerCoordinator(_ coordinator: SystemPickerCoordinator, didPickImage image: UIImage, in sheetViewController: SheetViewController)
    func systemPickerCoordinator(_ coordinator: SystemPickerCoordinator, didPickVideo video: AVAsset, in sheetViewController: SheetViewController)
}

// MARK: - System Picker Coordinator

final class SystemPickerCoordinator: BaseCoordinator<UIViewController> {

    // MARK: Properties
    private let mediaFetchService = MediaFetchService()
    private let loadingViewController: PickerLoadingViewController
    private let colorScheme: ColorScheme
    private lazy var pickerConfiguration: PHPickerConfiguration = {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.preferredAssetRepresentationMode = .current
        if #available(iOS 17.0, *) {
            config.disabledCapabilities = [.sensitivityAnalysisIntervention]
        }
        return config
    }()
    weak var output: PickerCoordinatorOutput?

    // MARK: Initialization
    
    init(rootViewController: UIViewController, colorScheme: ColorScheme, filter: PHPickerFilter?) {
        self.loadingViewController = PickerLoadingViewController(colorScheme: colorScheme)
        self.colorScheme = colorScheme
        super.init(rootViewController: rootViewController)
        self.pickerConfiguration.filter = filter
    }

    // MARK: Coordinator
    
    override func start() {
        // Present loading
        loadingViewController.modalPresentationStyle = .fullScreen
        rootViewController.present(loadingViewController, animated: true)
        
        // Present picker
        let pickerViewController = PHPickerViewController(configuration: pickerConfiguration)
        pickerViewController.delegate = self
        pickerViewController.modalTransitionStyle = .crossDissolve
        pickerViewController.modalPresentationStyle = loadingViewController.modalPresentationStyle
        loadingViewController.present(pickerViewController, animated: true)
    }
    
    private func dismissCoordinator() {
        #warning("Check for vbiew hierarchy state before dismissing")
        rootViewController.dismiss(animated: true)
        delegate?.childCoordinatorDidFinish(self)
    }
}

// MARK: - PHPickerViewControllerDelegate

extension SystemPickerCoordinator: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard let result = results.first else {
            #warning("Check system behaviour for dismissing and etc")
            dismissCoordinator()
            return
        }
        
        let infoViewController = SheetInfoViewController(title: "Fetching", colorScheme: colorScheme)
        let sheetViewController = SheetViewController(content: infoViewController)
        
        // Handle sheet dismissal
        sheetViewController.dismissHandler = { [weak self] in
            self?.mediaFetchService.cancel()
        }
        
        picker.present(sheetViewController, animated: true)
        processPickerResult(result, in: sheetViewController)
    }
    
    private func processPickerResult(_ result: PHPickerResult, in sheetViewController: SheetViewController) {
//        guard result.itemProvider.canLoadObject(ofClass: UIImage.self) else {
//            dismissCoordinator()
//            return
//        }
        
        mediaFetchService.fetchAsset(for: result, progress: { progress in
            // Update progress UI
        }, success: { [weak self] fetchedMedia in
            guard let self = self else { return }
            switch fetchedMedia {
            case .image(let image):
                self.output?.systemPickerCoordinator(self, didPickImage: image, in: sheetViewController)
            case .video(let video):
                self.output?.systemPickerCoordinator(self, didPickVideo: video, in: sheetViewController)
            }
        }, failure: { [weak self] error in
            guard let self = self else { return }
            let errorViewController = SheetInfoViewController(title: "Error", subtitle: "An unexpected error occurred.", colorScheme: self.colorScheme)
            sheetViewController.update(with: errorViewController)
        })
    }
}
