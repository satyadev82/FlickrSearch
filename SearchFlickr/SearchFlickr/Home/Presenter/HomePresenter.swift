

import Foundation
import UIKit

class HomePresenter {
    let view: HomeViewAdaptor?
    let wireframe: HomeWireframe
    let interactor: HomeInteractor
    let downloadInteractor: DownloadInteractor
    
    init(view: HomeViewAdaptor?,
         wireframe: HomeWireframe,
         interactor: HomeInteractor,
         downloadInteractor: DownloadInteractor) {
        self.view = view
        self.wireframe = wireframe
        self.interactor = interactor
        self.downloadInteractor = downloadInteractor
    }
    
    // Flickr Search
    func search(query: String) {
        self.interactor.search(query: query) { (_) in
            self.view?.refreshResults()
        }
    }
    
    func loadMoreResultsIfAvailable(query: String) {
        self.interactor.loadMore(query: query) { (_) in
            self.view?.refreshResults()
        }
    }
    
    func numberOfPhotos() -> Int {
        return self.interactor.numberOfPhotos()
    }
    
    func photo(at index: Int) -> Photo {
        return self.interactor.photo(at: index)
    }
    
    func resetPreviousSearch() {
        self.interactor.resetPreviousSearch()
    }
    
    // Download Photo
    func startDownload(_ photo: Photo) {
        return self.downloadInteractor.startDownload(_: photo)
    }
    
    func getImage(key: URL) -> UIImage? {
        return self.downloadInteractor.getImage(key: key)
    }
    
    func saveDownload(sourceURL: URL, downloadingTo location: URL) {
        self.downloadInteractor.saveDownload(sourceURL: sourceURL, downloadingTo: location)
    }
    
    func activeDownload(key: URL) -> Download? {
        return self.downloadInteractor.activeDownload(key: key)
    }
}
