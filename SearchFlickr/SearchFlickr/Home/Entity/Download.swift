

import Foundation

// This is download the photo against queried flickr result

class Download {
  var photo: Photo
  var task: URLSessionDownloadTask?
  var isDownloading = false
  var resumeData: Data?
  var progress: Float = 0

    init(photo: Photo) {
        self.photo = photo
    }
}
