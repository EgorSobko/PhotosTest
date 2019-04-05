import Foundation
import Api
import Kit

extension AddPhotoKitchen {
    enum ViewEvent {
        case viewDidLoad
    }
    
    enum Command {
        case present(AddPhotoViewController.ViewState)
        case presentError(title: String, description: String)
        case startLoadingTitles
        case stopLoadingTitles
    }
}

class AddPhotoKitchen: Kitchen {
    
    // MARK: - Properties
    weak var delegate: AnyKitchenDelegate<Command>?
    
    // MARK: - Private properties
    private let viewStateFactory: AddPhotoViewStateFactory
    private let photosService: PhotosService
    
    // MARK: - Init
    init(viewStateFactory: AddPhotoViewStateFactory, photosService: PhotosService) {
        self.viewStateFactory = viewStateFactory
        self.photosService = photosService
    }
    
    // MARK: - Methods
    func receive(event: AddPhotoKitchen.ViewEvent) {
        switch event {
        case .viewDidLoad:
            handleViewDidLoad()
        }
    }
    
    // MARK: - Private methods
    private func handleViewDidLoad() {
        let viewState = viewStateFactory.make(with: nil)
        delegate?.perform(.present(viewState))
        delegate?.perform(.startLoadingTitles)
        
        photosService.albums()
            .onSuccess { [weak self] response in
                guard let self = self else { return }
                
                let viewState = self.viewStateFactory.make(with: response)
                self.delegate?.perform(.present(viewState))
                self.delegate?.perform(.stopLoadingTitles)
        }
            .onFailure { [weak self] error in
                guard let self = self else { return }
                
                self.delegate?.perform(.presentError(title: "Error", description: error.localizedDescription))
                self.delegate?.perform(.stopLoadingTitles)
        }
    }
}
