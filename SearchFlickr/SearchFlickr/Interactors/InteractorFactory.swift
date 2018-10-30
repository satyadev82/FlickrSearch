

import Foundation

class InteractorFactory {
    static let sharedInstance = InteractorFactory()
    
    func queryService() -> QueryService {
        return QueryServiceImpl()
    }
    
    func homeScreenInteractor() -> HomeInteractor {
        return HomeInteractorImpl(service: self.queryService())
    }
    
    func downloadService(delegate: URLSessionDelegate) -> DownloadService {
        return DownloadServiceImpl(delegate: delegate)
    }
    
    func downloadInteractor(delegate: URLSessionDelegate) -> DownloadInteractor {
        let downloadService = self.downloadService(delegate: delegate)
        return DownloadInteractorImpl(downloadService: downloadService)
    }
}
