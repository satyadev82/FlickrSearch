

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell, NibLoadableView, ReusableView {

    @IBOutlet weak var photo: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        self.photo.image = nil
        super.prepareForReuse()
    }
}
