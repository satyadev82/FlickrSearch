

import Foundation
import UIKit

extension HomeViewController: URLSessionDownloadDelegate {
    
    // Save downloaded file
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let sourceURL = downloadTask.originalRequest?.url else { return }
        self.presenter.saveDownload(sourceURL: sourceURL, downloadingTo: location)
        if let download = self.presenter.activeDownload(key: sourceURL),
            let index = download.photo.index {
            DispatchQueue.main.async {
                if  self.presenter.numberOfPhotos() >= index {
                    self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
                }
            }
        }
    }
}
