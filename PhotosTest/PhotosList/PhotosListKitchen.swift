import Foundation
import Api
import Kit

extension PhotosListKitchen {
    enum ViewEvent {
        case viewDidLoad
        case didTapAddPhoto
    }
    
    enum Command {
        case present(PhotosListViewController.ViewState)
        case presentError(title: String, description: String)
        case startLoading
        case stopLoading
        case routeToAddPhoto
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
            handleViewDidLoad()
        case .didTapAddPhoto:
            delegate?.perform(.routeToAddPhoto)
        }
    }
    
    // MARK: - Private methods
    private func handleViewDidLoad() {
        delegate?.perform(.startLoading)
        photosService.photos()
            .onSuccess { [weak self] response in
                guard let self = self else { return }
                
                let viewState = self.viewStateFactory.make(with: response)
                self.delegate?.perform(.present(viewState))
                self.delegate?.perform(.stopLoading)
            }
            .onFailure { [weak self] error in
                guard let self = self else { return }
                
                self.delegate?.perform(.presentError(title: "Error", description: error.localizedDescription))
                self.delegate?.perform(.stopLoading)
        }
    }
}
