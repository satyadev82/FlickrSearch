

import Foundation

protocol HomeInteractor {
    
    func search(query: String, completion: @escaping (Bool)-> Void)
    func loadMore(query: String, completion: @escaping (Bool)-> Void)
    func numberOfPhotos() -> Int
    func photo(at index: Int) -> Photo
    func resetPreviousSearch()
}

class HomeInteractorImpl: HomeInteractor {
    
    private let service: QueryService
    private var photos: [Photo] = []
    private var perPageResult = 50
    private var currentPage = 1
    private var totalPages: Int?
    private var laodMoreInProgress: Bool = false
   
    init(service: QueryService) {
        self.service = service
    }
    
    func search(query: String, completion: @escaping (Bool)-> Void) {
        self.service.search(query: query,
                            perPageResult: perPageResult,
                            page: currentPage) { (flickrPhotos, errorMessage) in
                                if let notNilResponse = flickrPhotos {
                                    self.photos = notNilResponse.photos
                                    self.totalPages = notNilResponse.totalPages
                                }
                                completion(true)
        }
    }
    
    func loadMore(query: String, completion: @escaping (Bool)-> Void) {
        if self.laodMoreInProgress {
            return
        }
        guard let totalPages = self.totalPages else {return}
        if self.currentPage < totalPages {
            self.laodMoreInProgress = true
            currentPage += 1
            self.service.search(query: query,
                                perPageResult: perPageResult,
                                page: self.currentPage) { (flickrPhotos, errorMessage) in
                                    self.laodMoreInProgress = false
                                    if let photos = flickrPhotos?.photos,
                                        let pages = flickrPhotos?.totalPages  {
                                        self.photos.append(contentsOf: photos)
                                        self.totalPages = pages
                                    }
                                    completion(true)
            }
        }
    }
    
    func numberOfPhotos() -> Int {
        return self.photos.count
    }
    
    func photo(at index: Int) -> Photo {
        return self.photos[index]
    }
    
    func resetPreviousSearch() {
        self.service.cancelPreviousSearch()
        self.currentPage = 1
        self.photos.removeAll()
    }
}
