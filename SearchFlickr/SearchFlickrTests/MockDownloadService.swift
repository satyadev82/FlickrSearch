

import Foundation
import XCTest
@testable import SearchFlickr

class MockDownloadService: DownloadService {
    var inProgressDownload: [URL: Download] = [:]
    
    init() {
        
    }
    
    func startDownload(_ photo: Photo) {
        let download = Download(photo: photo)
        download.isDownloading = true
        inProgressDownload[photo.imageURLString] = download
    }
    
    func getActiveDownloads() -> [URL: Download] {
        return inProgressDownload
    }
}
