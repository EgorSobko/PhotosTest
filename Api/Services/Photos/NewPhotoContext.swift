import Foundation

public struct NewPhotoContext: Encodable {
    let title: String
    let albumTitle: String
    
    public init(title: String, albumTitle: String) {
        self.title = title
        self.albumTitle = albumTitle
    }
}
