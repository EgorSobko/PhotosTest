import Foundation
import Api

class AddPhotoViewStateFactory {
    
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
                     submitButtonTitle: "Submit",
                     availableTitles: availableTitles)
    }
}
