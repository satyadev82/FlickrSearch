

import Foundation
import UIKit

class Wireframe: NSObject {
    private(set) var navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

}
