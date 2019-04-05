import BrightFutures
import Foundation
import Result

class URLSessionRequestHandler: HTTPRequestHandler {
    private let urlSession: URLSession
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func handleRequest(_ urlRequest: URLRequest) -> Future<Data?, ServiceTransportError> {
        let promise = Promise<Data?, ServiceTransportError>()
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                promise.failure(ServiceTransportError.unexpected)
                return
            }
            
            if 200..<300 ~= httpResponse.statusCode {
                promise.success(data)
            } else {
                promise.failure(ServiceTransportError.network(error: error, httpURLResponse: httpResponse, errorBody: data))
            }
        }
        task.resume()
        
        return promise.future
    }
}
