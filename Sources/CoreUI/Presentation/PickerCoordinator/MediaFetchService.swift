//
//  Copyright © 2023 Draftz. All rights reserved.
//

import PhotosUI

final class MediaFetchService  {
    enum MediaFetchError: Error {
        case noContent
    }
    
    enum FetchedMedia {
        case image(UIImage)
        case video(AVAsset)
    }

    private var fetchProgress: Progress?
    private var progressTimer: Timer?
    private var isCancelled = false
    init() {
        //
    }
    func cancel() {
        progressTimer?.invalidate()
        progressTimer = nil
        fetchProgress?.cancel()
        fetchProgress = nil
    }
    
    func fetchAsset(for result: PHPickerResult,
                    progress: @escaping (Double) -> Void,
                    success: @escaping (FetchedMedia) -> Void,
                    failure: @escaping (Error) -> Void) {
        if result.itemProvider.canLoadObject(ofClass: PHLivePhoto.self) {
            return fetchLivePhotoContent(for: result, progress: progress, success: success, failure: failure)
        }
        
        if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
            return fetchImageContent(for: result, progress: progress, success: success, failure: failure)
        }
        
      //  fetchImage(for: result, progress: progress, success: success, failure: failure)
    }
    
    private func startTimer(progress: @escaping (Double) -> Void) {
        progressTimer = Timer(fire: .init(timeIntervalSinceNow: 0.1), interval: 0.1, repeats: true) { [weak self] _ in
            progress(self?.fetchProgress?.fractionCompleted ?? 0.0)
        }
        
        DispatchQueue.main.async {
            if let progressTimer = self.progressTimer {
                RunLoop.current.add(progressTimer, forMode: .common)
            }
        }
    }
    
    // MARK: - Live Photo
    
    private func fetchLivePhotoContent(for result: PHPickerResult,
                                       progress: @escaping (Double) -> Void,
                                       success: @escaping (FetchedMedia) -> Void,
                                       failure: @escaping (Error) -> Void) {
        fetchProgress = result.itemProvider.loadObject(ofClass: PHLivePhoto.self) { [weak self] (object: NSItemProviderReading?,
                                                                                                 error: Swift.Error?) in
            guard let self = self else {
                return
            }
            
            self.progressTimer?.invalidate()
            guard let object = object as? PHLivePhoto else {
                DispatchQueue.main.async {
                    failure(MediaFetchError.noContent)
                }
                return
            }
            
            let resources = PHAssetResource.assetResources(for: object)
            guard let videoResource = resources.first(where: { (resource: PHAssetResource) -> Bool in
                return resource.type == .pairedVideo
            }) else {
                DispatchQueue.main.async {
                    failure(MediaFetchError.noContent)
                }
                return
            }
            
            let identifier = videoResource.assetLocalIdentifier.isEmpty ?
            videoResource.originalFilename :
            videoResource.assetLocalIdentifier
            let url =  URL(fileURLWithPath: NSTemporaryDirectory())
                .appendingPathComponent(identifier.replacingOccurrences(of: "/", with: "_"))
                .appendingPathExtension("mov")
            try? FileManager.default.removeItem(at: url)
            
            let requestOptions = PHAssetResourceRequestOptions()
            requestOptions.isNetworkAccessAllowed = true
            PHAssetResourceManager.default().writeData(for: videoResource,
                                                       toFile: url,
                                                       options: requestOptions,
                                                       completionHandler: { _ in
                DispatchQueue.main.async {
                    let asset = AVURLAsset(url: url, options: [AVURLAssetPreferPreciseDurationAndTimingKey: true])
                    success(.video(asset))
                }
            })
        }
        
        startTimer(progress: progress)
    }
    
    // MARK: - Image
    
    
    func fetchImageContent(for result: PHPickerResult,
                    progress: @escaping (Double) -> Void,
                    success: @escaping (FetchedMedia) -> Void,
                    failure: @escaping (Error) -> Void) {
        isCancelled = false
        fetchProgress = result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier,
                                                                   completionHandler: { [weak self] (url: URL?, error: Error?) in
            guard self?.isCancelled == false else {
                return
            }
            self?.progressTimer?.invalidate()
            guard let url = url else {
                DispatchQueue.main.async {
                    failure(MediaFetchError.noContent)
                }
                return
            }
            
            let filename = result.assetIdentifier?.replacingOccurrences(of: "/", with: "") ?? url.lastPathComponent
            let targetURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename)
            try? FileManager.default.removeItem(at: targetURL)
            try? FileManager.default.copyItem(at: url, to: targetURL)
            
            DispatchQueue.main.async {
                let image = UIImage(contentsOfFile: targetURL.path)!
                success(.image(image))
                self?.isCancelled = true
                self?.cancel()
            }
        })
        
        startTimer(progress: progress)
    }
    
    
}
