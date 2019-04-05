import Foundation
import Api
import Kit

extension AddPhotoKitchen {
    enum ViewEvent {
        case viewDidLoad
        case didSelectRow(atIndex: Int)
        case submit(photoTitle: String)
    }
    
    enum Command {
        case present(AddPhotoViewController.ViewState)
        case presentError(title: String, description: String)
        case startLoadingTitles
        case stopLoadingTitles
        case resignFirstResponder
    }
}

class AddPhotoKitchen: Kitchen {
    
    // MARK: - Properties
    weak var delegate: AnyKitchenDelegate<Command>?
    
    // MARK: - Private properties
    private let viewStateFactory: AddPhotoViewStateFactory
    private let photosService: PhotosService
    private let photoTitleValidator: TextValidator
    
    private var albums: [AlbumsResponse.Album] = []
    private var selectedIndex: Int?
    
    // MARK: - Init
    init(viewStateFactory: AddPhotoViewStateFactory, photosService: PhotosService, photoTitleValidator: TextValidator) {
        self.viewStateFactory = viewStateFactory
        self.photosService = photosService
        self.photoTitleValidator = photoTitleValidator
    }
    
    // MARK: - Methods
    func receive(event: AddPhotoKitchen.ViewEvent) {
        switch event {
        case .viewDidLoad:
            handleViewDidLoad()
        case .didSelectRow(let index):
            handleDidSelect(atIndex: index)
        case .submit(let photoTitle):
            handleSubmit(withTitle: photoTitle)
        }
    }
    
    // MARK: - Private methods
    private func handleViewDidLoad() {
        let viewState = viewStateFactory.make(with: nil, selectedIndex: nil)
        delegate?.perform(.present(viewState))
        delegate?.perform(.startLoadingTitles)
        
        photosService.albums()
            .onSuccess { [weak self] response in
                guard let self = self else { return }
                
                self.albums = response.albums
                let viewState = self.viewStateFactory.make(with: response.albums, selectedIndex: nil)
                self.delegate?.perform(.present(viewState))
                self.delegate?.perform(.stopLoadingTitles)
        }
            .onFailure { [weak self] error in
                guard let self = self else { return }
                
                self.delegate?.perform(.presentError(title: "Error", description: error.localizedDescription))
                self.delegate?.perform(.stopLoadingTitles)
        }
    }
    
    private func handleDidSelect(atIndex index: Int) {
        let viewState: AddPhotoViewController.ViewState
        
        if let selectedIndex = selectedIndex, selectedIndex == index {
            viewState = viewStateFactory.make(with: albums, selectedIndex: nil)
            self.selectedIndex = nil
        } else {
            viewState = viewStateFactory.make(with: albums, selectedIndex: index)
            self.selectedIndex = index
        }
        
        delegate?.perform(.present(viewState))
    }
    
    private func handleSubmit(withTitle title: String) {
        delegate?.perform(.resignFirstResponder)
        if photoTitleValidator.isTextValid(title) {
            if let selectedIndex = selectedIndex {
                print(selectedIndex)
            } else {
                delegate?.perform(.presentError(title: "No album title", description: "Please, select album title"))
            }
        } else {
            delegate?.perform(.presentError(title: "Invalid photo title", description: "Photo title should be at least 8 characters"))
        }
    }
}
