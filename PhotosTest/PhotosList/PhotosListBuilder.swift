import Foundation
import Kit
import Api

class PhotosListBuilder {
    
    // MARK: - Private properties
    private let viewControllerFactory: ViewControllerFactory
    private let photosServiceFactory: PhotosServiceFactory
    private let photosListRoutable: PhotosListRoutable

    // MARK: - Init
    init(viewControllerFactory: ViewControllerFactory, photosServiceFactory: PhotosServiceFactory, photosListRoutable: PhotosListRoutable) {
        self.viewControllerFactory = viewControllerFactory
        self.photosServiceFactory = photosServiceFactory
        self.photosListRoutable = photosListRoutable
    }
    
    // MARK: - Methods
    func buildViewController() -> UIViewController {
        let photosViewController = viewControllerFactory.createViewController(type: PhotosListViewController.self,
                                                                              storyboardName: "PhotosList",
                                                                              storyboardIdentifer: String(describing: PhotosListViewController.self))
        let photosKitchen = buildKitchen()
        let anyKitchen = AnyKitchen(photosKitchen)
        anyKitchen.delegate = AnyKitchenDelegate(photosViewController)
        photosViewController.inject(kitchen: anyKitchen, router: photosListRoutable)
        
        return photosViewController
    }
    
    // MARK: - Private methods
    private func buildKitchen() -> PhotosListKitchen {
        let viewStateFactory = PhotosListViewStateFactory()
        let photosService = photosServiceFactory.make()
        
        return PhotosListKitchen(viewStateFactory: viewStateFactory, photosService: photosService)
    }
}
