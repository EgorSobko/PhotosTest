import Foundation

public struct QueryParameter {
    public let name: String
    public let value: String?
}

public protocol Endpoint {
    associatedtype ReturnType: Decodable
    associatedtype ErrorType: Error
    
    func headers() -> [String: String]?
    func queryParameters() -> [QueryParameter]?
    func httpBody() -> Data?
}



extension Endpoint {
    static var name: String {
        return String(describing: self)
    }
    
    func headers() -> [String: String]? {
        return nil
    }
    
    func queryParameters() -> [QueryParameter]? {
        return nil
    }
    
    func httpBody() -> Data? {
        return nil
    }
}
