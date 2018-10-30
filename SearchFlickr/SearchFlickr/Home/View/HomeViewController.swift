

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var label: UILabel!
    
    var presenter: HomePresenter!
    private var interItemSpacing: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(PhotoCollectionViewCell.self)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = interItemSpacing
        self.collectionView.collectionViewLayout = flowLayout
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.title = "Flickr Search"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func calculateItemSize() -> CGSize {
        // As of now create 3 column per row
        // Change this value to adjust number of column
       let width = (UIScreen.main.bounds.width - (self.interItemSpacing*3))/3
       return CGSize(width: width, height: width)
    }
}

extension HomeViewController: HomeViewAdaptor {
    
    func refreshResults() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.collectionView.isHidden = !(self.presenter.numberOfPhotos() > 0)
            self.label?.isHidden = !self.collectionView.isHidden
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter.numberOfPhotos()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PhotoCollectionViewCell
        cell.backgroundColor = .gray
        let photo = self.presenter.photo(at: indexPath.row)
        photo.index = indexPath.row
        if let savedImage = self.presenter.getImage(key: photo.imageURLString) {
            cell.photo?.image = savedImage
        } else {
            self.presenter.startDownload(photo)
        }
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.calculateItemSize()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2,
                            left: 2,
                            bottom: 2,
                            right: 2)
    }
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query =  searchBar.text, !query.isEmpty {
            self.presenter.search(query: query)
        }
        self.searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.presenter.resetPreviousSearch()
        self.searchBar.endEditing(true)
        self.searchBar.text = nil
        self.collectionView.reloadData()
    }
}

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Auto infinite result loading
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        if let query = self.searchBar.text, !query.isEmpty,
            bottomEdge >= scrollView.contentSize.height {
            self.presenter.loadMoreResultsIfAvailable(query: query)
        }
    }
}
