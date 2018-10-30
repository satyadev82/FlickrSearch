

import Foundation

class Photo {
    var id: String
    var owner: String
    var seceret: String
    var server: String
    var farm: Int
    //Helper
    var index: Int?
    var downloaded = false

    init(id: String, owner: String, seceret: String, server: String, farm: Int) {
        self.id = id
        self.owner = owner
        self.seceret = seceret
        self.server = server
        self.farm = farm
    }
}

extension Photo {
    var imageURLString: URL {
        return URL(string: "http://farm1.static.flickr.com/\(self.server)/\(self.id)_\(self.seceret).jpg")!
    }
}

class FlickrSearch {
    var totalPages: Int
    var photos: [Photo] = []
    
    init(totalPages: Int, photos: [Photo]) {
        self.totalPages = totalPages
        self.photos = photos
    }
    
}
