import Foundation
import Api
import Kit

extension PhotosListKitchen {
    enum ViewEvent {
        case viewDidLoad
    }
    
    enum Command {
        case present(PhotosListViewController.ViewState)
    }
}

class PhotosListKitchen: Kitchen {
    
    // MARK: - Properties
    weak var delegate: AnyKitchenDelegate<Command>?
    
    // MARK: - Private properties
    private let viewStateFactory: PhotosListViewStateFactory
    private let photosService: PhotosService

    // MARK: - Init
    init(viewStateFactory: PhotosListViewStateFactory, photosService: PhotosService) {
        self.viewStateFactory = viewStateFactory
        self.photosService = photosService
    }
    
    // MARK: - Methods
    func receive(event: PhotosListKitchen.ViewEvent) {
        switch event {
        case .viewDidLoad:
            delegate?.perform(.present(PhotosListViewController.ViewState()))
        }
    }
}
