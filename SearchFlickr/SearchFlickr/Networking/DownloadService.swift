

import Foundation
import UIKit

protocol DownloadService {
    func startDownload(_ photo: Photo)
    func getActiveDownloads() -> [URL: Download]
}

class DownloadServiceImpl: DownloadService {
    private var activeDownloads: [URL: Download] = [:]
    private weak var delegate: URLSessionDelegate?
    
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "bgSessionConfiguration")
        return URLSession(configuration: configuration, delegate: self.delegate, delegateQueue: nil)
    }()
    
    
    init(delegate: URLSessionDelegate) {
        self.delegate = delegate
    }
    
    func startDownload(_ photo: Photo) {
        let download = Download(photo: photo)
        download.task = downloadsSession.downloadTask(with: photo.imageURLString)
        download.task!.resume()
        download.isDownloading = true
        activeDownloads[download.photo.imageURLString] = download
    }
    
    func getActiveDownloads() -> [URL: Download]  {
        return self.activeDownloads
    }
    
}

