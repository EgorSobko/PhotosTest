import Foundation

public class PhotosServiceFactory {
    
    public init() { }
    
    public func make() -> PhotosService {
        let configuration = URLSessionConfiguration.default
        let requestHandler = URLSessionRequestHandler(urlSession: URLSession(configuration: configuration))
        
        return ServiceImplementation.PhotosService(requestHandler: requestHandler)
    }
}
