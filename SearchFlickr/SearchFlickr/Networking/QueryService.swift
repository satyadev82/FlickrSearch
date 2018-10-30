

import Foundation

private var kApiKey = "Eneter_Flickr_Api_Key"
typealias QueryResult = (FlickrSearch?, String?) -> ()

protocol QueryService {
    func cancelPreviousSearch()
    func search(query: String, perPageResult: Int, page: Int, completion: @escaping QueryResult)
}

// Runs query data task, and stores results in array of photos
class QueryServiceImpl: QueryService {

    private let defaultSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    private var errorMessage: String?
    
    
    func cancelPreviousSearch() {
        dataTask?.cancel()
    }
    
    func search(query: String, perPageResult: Int, page: Int, completion: @escaping QueryResult) {
        if var urlComponents = URLComponents(string: "https://api.flickr.com/services/rest/") {
            urlComponents.query = "method=flickr.photos.search&api_key=\(kApiKey)&format=json&nojsoncallback=1&safe_search=1&text=\(query)&per_page=\(perPageResult)&page=\(page)"
            guard let url = urlComponents.url else { return }
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }
                if let error = error {
                    self.errorMessage = "DataTask error: " + error.localizedDescription + "\n"
                    completion(nil, self.errorMessage)
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 ||  response.statusCode == 202 {
                    self.updateSearchResults(data, completion: completion)
                }
            }
            dataTask?.resume()
        }
    }
    
    fileprivate func updateSearchResults(_ data: Data, completion: @escaping QueryResult) {
        typealias JSONDictionary = [String: Any]
        var response: JSONDictionary?
        var photos: [Photo] = []

        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
        } catch let parseError as NSError {
            errorMessage = "JSONSerialization error: \(parseError.localizedDescription)\n"
            completion(nil, errorMessage)
            return
        }
        
        guard let notNilDic = response,
            let photosDic = notNilDic["photos"] as? JSONDictionary ,
            let totalPages = photosDic["pages"] as? Int,
            let array = photosDic["photo"] as? [Any] else {
            errorMessage = "Dictionary does not contain results key\n"
            completion(nil, errorMessage)
            return
        }
        
        //print("photosDic: \(photosDic) \ntotalPages:\(totalPages)")
        
        for trackDictionary in array {
            if let trackDictionary = trackDictionary as? JSONDictionary,
                let id = trackDictionary["id"] as? String,
                let seceret = trackDictionary["secret"] as? String,
                let owner = trackDictionary["owner"] as? String,
                let server = trackDictionary["server"] as? String,
                let farm =  trackDictionary["farm"] as? Int {
                let photo = Photo(id: id,
                                  owner: owner,
                                  seceret: seceret,
                                  server: server,
                                  farm: farm)
                photos.append(photo)
            }
        }
        let flickrSearch = FlickrSearch(totalPages: totalPages, photos: photos)
        completion(flickrSearch, errorMessage)
    }
    
}
