import BrightFutures
import Foundation
import Result

public protocol HTTPRequestHandler {
    func handleRequest(_ urlRequest: URLRequest) -> Future<Data, ServiceTransportError>
}
