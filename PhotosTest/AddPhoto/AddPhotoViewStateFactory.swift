import Foundation
import Api

class AddPhotoViewStateFactory {
    
    // MARK: - Methods
    func make(with albums: [AlbumsResponse.Album]?, selectedIndex: Int?) -> AddPhotoViewController.ViewState {
        var availableTitles: [AddPhotoViewController.ViewState.Title] = []
        if let albums = albums {
            for i in 0..<albums.count {
                let album = albums[i]
                availableTitles.append(.init(description: album.title, isSelected: i == selectedIndex))
            }
        }
        
        return .init(photoTitleDescription: "Please, choose photo title",
                     albumTitleDescription: "Please, pick available album title",
                     submitButton: makeSubmitButtonViewState(isActive: false),
                     availableTitles: availableTitles)
    }
    
    func makeSubmitButtonViewState(isActive: Bool) -> AddPhotoViewController.ViewState.SubmitButton {
        return .init(title: "Submit", isActive: isActive)
    }
}
