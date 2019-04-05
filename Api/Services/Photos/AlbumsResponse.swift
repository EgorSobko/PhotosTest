import Foundation

public struct AlbumsResponse: Decodable {
    public struct Album: Decodable {
        let userId: Int
        let id: Int
        public let title: String
    }
    
    public let albums: [Album]
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        self.albums = try container.decode([Album].self)
    }
}
