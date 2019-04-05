import Foundation
import Api

class PhotosListViewStateFactory {
    
    func make(with response: PhotosResponse) -> PhotosListViewController.ViewState {
        let cellViewStates = response.photos
            .sorted(by: { $0.title.count < $1.title.count })
            .map { PhotoTableViewCell.ViewState(imageURL: $0.thumbnailUrl, description: $0.title) }
        
        return .init(cellViewStates: cellViewStates)
    }
}
