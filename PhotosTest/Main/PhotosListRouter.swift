import UIKit
import Kit
import Api

protocol PhotosListRoutable {
    
}

class PhotosListRouter {
    
    private(set) weak var currentViewController: UIViewController?
    
    func execute(in window: UIWindow?) {
        let viewControllerFactory = ViewControllerFactory()
        let photosServiceFactory = PhotosServiceFactory()
        
        let builder = PhotosListBuilder(viewControllerFactory: viewControllerFactory, photosServiceFactory: photosServiceFactory, photosListRoutable: self)
        let photosListViewController = builder.buildViewController()
        window?.rootViewController = photosListViewController
        window?.makeKeyAndVisible()
        
        currentViewController = photosListViewController
    }
}

extension PhotosListRouter: PhotosListRoutable {
    
}
