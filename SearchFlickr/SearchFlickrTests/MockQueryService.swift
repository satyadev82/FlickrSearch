

import Foundation
import XCTest
@testable import SearchFlickr

class MockQueryService: QueryService {
    
    init() {
        
    }
    
    func cancelPreviousSearch() {
        
    }
    
    func search(query: String, perPageResult: Int, page: Int, completion: @escaping QueryResult) {
        completion(nil, "Something went wrong")
    }
}
