

import Foundation
import XCTest
@testable import SearchFlickr

class DownloadInteractorSpec: XCTestCase {
    
    var downloadInteractor: MockDownloadInteractor!
    var photo: Photo!
   
    override func setUp() {
        super.setUp()
        let mockDownloadService = MockDownloadService()
        downloadInteractor = MockDownloadInteractor(service: mockDownloadService)
        photo = Photo(id: "44713747285", owner: "165175204@N05", seceret: "263c5d2cf6", server: "1933", farm: 2)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        downloadInteractor = nil
        photo = nil
    }
    
    func testCachedImage() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let image = self.downloadInteractor.getImage(key: URL(string: "http://farm1.static.flickr.com/578/23451156376_8983a8ebc7.jpg")!)
        // Expecting Nil
        XCTAssertNil(image)
    }
    
    func testActiveDownload() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        self.downloadInteractor.startDownload(self.photo)
        let activeDownload = self.downloadInteractor.activeDownload(key: self.photo.imageURLString)
        // Expecting Nil
        XCTAssertNotNil(activeDownload?.photo)
        // Download should begin
        XCTAssertTrue(activeDownload!.isDownloading)
    }    
}
