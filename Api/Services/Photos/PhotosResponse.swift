import Foundation

public struct PhotosResponse: Decodable {
    struct Photo: Decodable {
        let albumId: Int
        let id: Int
        let title: String
        let url: URL?
        let thumbnailUrl: URL?
    }
    
    enum CodingKeys: String, CodingKey {
        case photos
    }
    
    let photos: [Photo]
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.photos = try container.decode([Photo].self, forKey: CodingKeys.photos)
    }
}
