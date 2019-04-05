import Foundation
import Kit
import Api

class AddPhotoBuilder {
    
    // MARK: - Private properties
    private let viewControllerFactory: ViewControllerFactory
    private let photosServiceFactory: PhotosServiceFactory
    
    // MARK: - Init
    init(viewControllerFactory: ViewControllerFactory, photosServiceFactory: PhotosServiceFactory) {
        self.viewControllerFactory = viewControllerFactory
        self.photosServiceFactory = photosServiceFactory
    }
    
    // MARK: - Methods
    func buildViewController() -> UIViewController {
        let addPhotoViewController = viewControllerFactory.createViewController(type: AddPhotoViewController.self,
                                                                              storyboardName: "AddPhoto",
                                                                              storyboardIdentifer: String(describing: AddPhotoViewController.self))
        let addPhotoKitchen = buildKitchen()
        let anyKitchen = AnyKitchen(addPhotoKitchen)
        anyKitchen.delegate = AnyKitchenDelegate(addPhotoViewController)
        addPhotoViewController.inject(kitchen: anyKitchen)
        
        return addPhotoViewController
    }
    
    // MARK: - Private methods
    private func buildKitchen() -> AddPhotoKitchen {
        let viewStateFactory = AddPhotoViewStateFactory()
        let photosService = photosServiceFactory.make()
        
        return AddPhotoKitchen(viewStateFactory: viewStateFactory, photosService: photosService)
    }
}
