import Foundation
import Api
import Kit

extension AddPhotoKitchen {
    enum ViewEvent {
        case viewDidLoad
        case didSelectRow(atIndex: Int)
        case submit(photoTitle: String)
        case didTapReturn
        case didChangePhotoTitle(String)
    }
    
    enum Command {
        case present(AddPhotoViewController.ViewState)
        case presentSubmitButtonViewState(AddPhotoViewController.ViewState.SubmitButton)
        case presentError(title: String, description: String)
        case startLoadingTitles
        case stopLoadingTitles
        case resignFirstResponder
        case presentSuccess(title: String)
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
    private var photoTitle: String = ""
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
            handleDidChangePhotoTitle(photoTitle, selectedIndex: selectedIndex)
        case .submit(let photoTitle):
            handleSubmit(withTitle: photoTitle)
        case .didTapReturn:
            delegate?.perform(.resignFirstResponder)
        case .didChangePhotoTitle(let title):
            photoTitle = title
            handleDidChangePhotoTitle(photoTitle, selectedIndex: selectedIndex)
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
    
    private func handleDidChangePhotoTitle(_ title: String, selectedIndex: Int?) {
        let isActive = isSubmitButtonActive(withTitle: title, selectedIndex: selectedIndex)
        let buttonViewState = viewStateFactory.makeSubmitButtonViewState(isActive: isActive)
        delegate?.perform(.presentSubmitButtonViewState(buttonViewState))
    }
    
    private func isSubmitButtonActive(withTitle title: String, selectedIndex: Int?) -> Bool {
        if photoTitleValidator.isTextValid(title) && selectedIndex != nil {
            return true
        } else {
            return false
        }
    }
    
    private func handleSubmit(withTitle title: String) {
        guard let selectedIndex = selectedIndex else { return }
        
        let context = NewPhotoContext(title: title, albumTitle: albums[selectedIndex].title)
        photosService.createNewPhoto(with: context)
            .onSuccess { [weak self] _ in
                guard let self = self else { return }
                
                self.delegate?.perform(.presentSuccess(title: "You did it!"))
            }
            .onFailure { [weak self] error in
                guard let self = self else { return }
                
                self.delegate?.perform(.presentError(title: "Error", description: error.localizedDescription))
                self.delegate?.perform(.stopLoadingTitles)
        }
    }
}
