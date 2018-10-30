

import Foundation

import Foundation
import XCTest
@testable import SearchFlickr


class MockDownloadInteractor: DownloadInteractor {
    let service: MockDownloadService
    
    init(service: MockDownloadService) {
        self.service = service
    }
    
    func startDownload(_ photo: Photo) {
        self.service.startDownload(photo)
    }
    
    func getImage(key: URL) -> UIImage? {
        return nil
    }
    
    func saveDownload(sourceURL: URL, downloadingTo location: URL) {

    }
    
    func activeDownload(key: URL) -> Download? {
        return self.service.getActiveDownloads()[key]
    }
}
