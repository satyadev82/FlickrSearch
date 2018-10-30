

import Foundation
import XCTest
@testable import SearchFlickr


class MockHomeInteractor: HomeInteractor {
    let service: MockQueryService
   
    init(service: MockQueryService) {
        self.service = service
    }

    func search(query: String, completion: @escaping (Bool)-> Void) {
        self.service.search(query: query, perPageResult: 25, page: 1) { (results, errorMessage) in
            if errorMessage == nil, let photos = results?.photos, !photos.isEmpty {
                completion(true)
                return
            }
            completion(false)
        }
    }
    
    func loadMore(query: String, completion: @escaping (Bool)-> Void) {
        
    }
    
    func numberOfPhotos() -> Int {
        return 10
    }
    
    func photo(at index: Int) -> Photo {
        let photo = Photo(id: "44713747285", owner: "165175204@N05", seceret: "263c5d2cf6", server: "1933", farm: 2)
        return photo
    }
    
    func resetPreviousSearch() {
        
    }

}
