# FlickrSearch

This is a sample application developed for personal learning

### Feature ###
* This App uses the Flickr image search API.
* Search any text and display the results in a 3-column scrollable view.
* It support endless scrolling, automatically requesting and displaying more images(for existing query) when the user scrolls to the bottom of the view.
* Auto downloading of images and cache them. 
* As soon tap on cancel button all searched result removed from scrollable view.

### Requirement ###
* Xcode: 9.4.1
* Programming language: Swift 4.0
* Device supported: All 
* Orientation:  All
* iOS Support: 10.0 and above


### Project Architecture followed ###
* VIPER

### How to use it ###
To safeguard against the misuse of the flickr api key. We have removed from code. kindly add correct api key in QueryService(kApiKey) class to run this application correctly. 
I have tested it using the provided api key.

### Basic understanding ###

* HomeViewController: This is a controller class having UI logic and also handle the user action.  

* HomeInteractor: This class is responsible for flickr search request and keep the flickr searched data in form of Photo model. It has couple of properties (`perPageResult`) which drive application logic. As of now application display 50 result per flickr request you can change it to any desire value but max allowed size is 500 result per page. 
Reference link --  https://www.flickr.com/services/api/flickr.photos.search.html

* DownloadInteractor: This class is responsible for downloading the image for any flickr queried result. This class has several method which are being used to cache the image and if required return the cached image. As of now `disk` caching is applied in code. You can use other option available like `inMemory`.

* DownloadService: This is a network class which take care image download task.

* QueryService: Network class which take care the basic network request and process the received response.


### Unit test cases ###
 * I have also written unit test cases. You can run them by tapping command + U keys together.
