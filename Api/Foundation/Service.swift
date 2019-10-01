import BrightFutures
import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

public enum ServiceTransportError: Error {
    case network(error: Error?, httpURLResponse: HTTPURLResponse?, errorBody: Data?)
    case objectMapping(error: Error)
    case unexpected
}

public enum ServiceImplementation { }

open class Service {
    
    private let requestHandler: HTTPRequestHandler
    
    open var config: ServiceConfiguration {
        fatalError("Subclasses must override this property to declare their configuration.")
    }
    
    public init(requestHandler: HTTPRequestHandler) {
        self.requestHandler = requestHandler
    }
    
    public func request<T: Endpoint>(_ endpoint: T) -> Future<T.ReturnType, ServiceTransportError> {
        let promise = Promise<T.ReturnType, ServiceTransportError>()
        promise.completeWith(processRequest(endpoint))
        
        return promise.future
    }
    
    private func processRequest<T: Endpoint>(_ endpoint: T) -> Future<T.ReturnType, ServiceTransportError> {
        let theURLRequest = urlRequest(for: endpoint)
        
        let requestPromise = Promise<T.ReturnType, ServiceTransportError>()
        requestHandler.handleRequest(theURLRequest).onComplete { result in
            switch result {
            case .success(let data):
                let mappedResult = self.mapValue(endpoint, data)
                switch mappedResult {
                case .success(let mappedValue):
                    requestPromise.success(mappedValue)
                case .failure(let error):
                    requestPromise.failure(error)
                }
            case .failure(let error):
                requestPromise.failure(error)
            }
        }
        
        return requestPromise.future
    }
    
    func urlRequest<T: Endpoint>(for endpoint: T) -> URLRequest {
        guard let baseURL = URL(string: config.host(for: endpoint)) else {
            fatalError("baseURL should be always valid")
        }
        let resource = config.resource(for: endpoint)
        
        guard var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            return URLRequest(url: baseURL)
        }
        
        urlComponents.path = resource
        
        let queryItems: [URLQueryItem] = endpoint.queryParameters()?.compactMap { parameter in
            let name = parameter.name
            let value = parameter.value
            
            return URLQueryItem(name: name, value: value)
            } ?? []
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            return URLRequest(url: baseURL)
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = config.method(for: endpoint)
        request.allHTTPHeaderFields = endpoint.headers()
        
        if let body = endpoint.httpBody() {
            request.httpBody = body
        }
        
        return request
    }
    
    private func mapValue<T: Endpoint>(_ endpoint: T, _ responseData: Data?) -> Result<T.ReturnType, ServiceTransportError> {
        guard let responseData = responseData else {
            return Result(error: ServiceTransportError.unexpected)
        }
        
        do {
            let decoder = JSONDecoder()
            let decodedValue = try decoder.decode(T.ReturnType.self, from: responseData)
            
            return Result(value: decodedValue)
        }
        catch let decodingError as DecodingError {
            return Result(error: ServiceTransportError.objectMapping(error: decodingError))
        }
        catch {
            return Result(error: ServiceTransportError.unexpected)
        }
    }
}
