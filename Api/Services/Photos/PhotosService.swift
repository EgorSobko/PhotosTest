import Foundation
import BrightFutures

public protocol PhotosService {
    func photos() -> Future<PhotosResponse, ServiceTransportError>
}

extension ServiceImplementation {
    
    class PhotosService: Service, Api.PhotosService {
        
        override public var config: ServiceConfiguration {
            return ServiceConfiguration(
                endpointConfiguration: EndpointConfiguration(
                    host: "https://jsonplaceholder.typicode.com",
                    operations: [
                        GetPhotos.name: OperationConfiguration(resource: "/photos", method: .get),
                        PostPhotos.name: OperationConfiguration(resource: "/photos", method: .post),
                        GetAlbums.name: OperationConfiguration(resource: "/albums", method: .get)
                    ])
            )
        }
        
        // MARK: - Public Methods
        
        public func photos() -> Future<PhotosResponse, ServiceTransportError> {
            return request(GetPhotos())
        }
        
        // MARK: - Private
        
        private struct GetPhotos: Endpoint {
            typealias ReturnType = PhotosResponse
            typealias ErrorType = ServiceTransportError
        }
        
        private struct PostPhotos: Endpoint {
            typealias ReturnType = IgnorableResponse
            typealias ErrorType = ServiceTransportError
            
            private let context: NewPhotoContext
            
            init(context: NewPhotoContext) {
                self.context = context
            }
            
            func headers() -> [String : String]? {
                return [
                    "Content-Type": "application/json"
                ]
            }
            
            func httpBody() -> Data? {
                return try? JSONEncoder().encode(context)
            }
        }
        
        private struct GetAlbums: Endpoint {
            typealias ReturnType = AlbumsResponse
            typealias ErrorType = ServiceTransportError
        }        
    }
}
