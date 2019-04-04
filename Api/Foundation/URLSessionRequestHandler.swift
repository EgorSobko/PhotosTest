import BrightFutures
import Foundation
import Result

class URLSessionRequestHandler: HTTPRequestHandler {
    private let urlSession: URLSession
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func handleRequest(_ urlRequest: URLRequest) -> Future<Data, ServiceTransportError> {
        let promise = Promise<Data, ServiceTransportError>()
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                promise.failure(ServiceTransportError.network(error: error, httpURLResponse: response, errorBody: data))
            } else if let data = data {
                promise.success(data)
            }
        }
        task.resume()
        
        return promise.future
    }
}
