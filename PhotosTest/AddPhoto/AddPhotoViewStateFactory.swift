import Foundation
import Api

class AddPhotoViewStateFactory {
    
    func make(with response: AlbumsResponse?) -> AddPhotoViewController.ViewState {
        let availableTitles = response?.albums.compactMap { $0.title } ?? []
        
        return .init(photoTitleDescription: "Please, choose photo title",
                     albumTitleDescription: "Please, pick available album title",
                     submitButtonTitle: "Submit",
                     availableTitles: availableTitles)
    }
}
