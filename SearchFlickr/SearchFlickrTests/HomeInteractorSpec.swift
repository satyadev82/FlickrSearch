

import Foundation
import XCTest
@testable import SearchFlickr

class HomeInteractorSpec: XCTestCase {
    
    var queryInteractor: MockHomeInteractor!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let queryService = MockQueryService()
        queryInteractor =  MockHomeInteractor(service: queryService)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        queryInteractor = nil
    }
    
    func testSearchPhoto() {
        var isSuccess = true
        let expectation = self.expectation(description: "Search Flickr")
        self.queryInteractor.search(query: "Kitten") { (success) in
            isSuccess = success
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
        XCTAssertFalse(isSuccess)
    }
    
    func testPhotos() {
        let numberOfPhotos = self.queryInteractor.numberOfPhotos()
        XCTAssertGreaterThan(numberOfPhotos, 0)
    }
    
    func testPhoto() {
        let photo = self.queryInteractor.photo(at: 0)
        XCTAssertNotNil(photo)
        XCTAssertNotNil(photo.farm)
        XCTAssertNotNil(photo.server)
        XCTAssertNotNil(photo.owner)
        XCTAssertNotNil(photo.seceret)
        XCTAssertNotNil(photo.imageURLString)
    }
}
