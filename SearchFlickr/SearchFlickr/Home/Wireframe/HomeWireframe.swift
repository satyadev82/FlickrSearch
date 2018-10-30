

import Foundation
import UIKit

protocol HomeWireframe {
    
}

class HomeWireframeImpl: Wireframe, HomeWireframe {
    
    static func showRoot(navigationController: UINavigationController) {
        let wireframe = HomeWireframeImpl(navigationController: navigationController)
        let view = HomeViewController.instantiateFromStoryboard()
        let interactor = InteractorFactory.sharedInstance.homeScreenInteractor()
        let downloadInteractor = InteractorFactory.sharedInstance.downloadInteractor(delegate: view)
        let presenter = HomePresenter(view: view,
                                      wireframe: wireframe,
                                      interactor: interactor,
                                      downloadInteractor: downloadInteractor)
        view.presenter = presenter
        navigationController.viewControllers = [view]
    }
}
