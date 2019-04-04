import Foundation

public struct AlbumsResponse: Decodable {
    let userId: Int
    let id: Int
    let title: String
}
