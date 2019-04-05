import Foundation

public struct PhotosResponse: Decodable {
    public struct Photo: Decodable {
        let albumId: Int
        let id: Int
        public let title: String
        public let url: URL?
        public let thumbnailUrl: URL?
    }
    
    enum CodingKeys: String, CodingKey {
        case photos
    }
    
    public let photos: [Photo]
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.photos = try container.decode([Photo].self, forKey: CodingKeys.photos)
    }
}
