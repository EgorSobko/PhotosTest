import UIKit
import Kit
import Api

class AddPhotoRouter {
    
    // MARK: - Properties
    private(set) weak var currentViewController: UIViewController?
    
    // MARK: - Methods
    func execute(in viewController: UIViewController) {
        let viewControllerFactory = ViewControllerFactory()
        let photosServiceFactory = PhotosServiceFactory()
        
        let builder = AddPhotoBuilder(viewControllerFactory: viewControllerFactory, photosServiceFactory: photosServiceFactory)
        let allPhotoViewController = builder.buildViewController()
        viewController.navigationController?.pushViewController(allPhotoViewController, animated: true)
        
        currentViewController = allPhotoViewController
    }
}
