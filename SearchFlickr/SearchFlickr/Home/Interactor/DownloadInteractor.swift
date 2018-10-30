

import Foundation
import  UIKit

protocol DownloadInteractor {
    func startDownload(_ photo: Photo)
    func getImage(key: URL) -> UIImage?
    func saveDownload(sourceURL: URL, downloadingTo location: URL)
    func activeDownload(key: URL) -> Download?
}

enum CacheType {
    case inMemory
    case disk
}

class DownloadInteractorImpl : DownloadInteractor {
    
    let downloadService: DownloadService
    private var cache: NSCache<AnyObject, AnyObject>
    private var type: CacheType = .disk

    init(downloadService: DownloadService) {
        self.downloadService = downloadService
        self.cache = NSCache()
    }
    
    func startDownload(_ photo: Photo) {
        self.downloadService.startDownload(photo)
    }
    
    func getImage(key: URL) -> UIImage? {
        if self.type == .inMemory {
            return self.cache.object(forKey: key as AnyObject) as? UIImage
        } else {
            let downloadImageURL = self.downloadPath(for: key)
            return UIImage(contentsOfFile: downloadImageURL.path)
        }
    }
    
    func saveDownload(sourceURL: URL, downloadingTo location: URL) {
        var activeDownloads = self.downloadService.getActiveDownloads()
        let download = activeDownloads[sourceURL]
        activeDownloads[sourceURL] = nil
        
        if self.type == .inMemory , let image = UIImage(contentsOfFile: location.path) {
            self.cache.setObject(image, forKey: sourceURL as AnyObject)
            download?.photo.downloaded = true
        } else {
            let destinationURL = self.downloadPath(for: sourceURL)
            let fileManager = FileManager.default
            try? fileManager.removeItem(at: destinationURL)
            do {
                try fileManager.copyItem(at: location, to: destinationURL)
                download?.photo.downloaded = true
            } catch let error {
                print("Could not copy file to disk: \(error.localizedDescription)")
            }
        }
    }
    
    func activeDownload(key: URL) -> Download? {
        return self.downloadService.getActiveDownloads()[key]
    }
    
    private func downloadPath(for url: URL) -> URL {
        let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return documentsPath.appendingPathComponent(url.lastPathComponent)
    }

}
