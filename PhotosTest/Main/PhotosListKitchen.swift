import Foundation
import Api
import Kit

extension PhotosListKitchen {
    enum ViewEvent {}
    
    enum Command {}
}

class PhotosListKitchen {
    
    // MARK: - Properties
    weak var delegate: AnyKitchenDelegate<Command>?
    
    // MARK: - Private properties
    private let viewStateFactory: PhotosListViewStateFactory
    private let photosService: PhotosService

    init(viewStateFactory: PhotosListViewStateFactory, photosService: PhotosService) {
        self.viewStateFactory = viewStateFactory
        self.photosService = photosService
    }
}
