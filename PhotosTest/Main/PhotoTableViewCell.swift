import UIKit
import Nuke

extension PhotoTableViewCell {
    struct ViewState {
        let imageURL: URL?
        let description: String
    }
}

class PhotoTableViewCell: UITableViewCell {
    
    // MARK: - Private outlets
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var photoDescriptionLabel: UILabel!
    
    private var imageTask: ImageTask?
    
    // MARK: - Methods
    func configure(with viewState: ViewState) {
        imageTask?.cancel()
        photoImageView.image = nil
        
        imageTask = viewState.imageURL.flatMap { Nuke.loadImage(with: $0, into: photoImageView) }
        photoDescriptionLabel.text = viewState.description
    }
}
