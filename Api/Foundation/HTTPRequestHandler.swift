import BrightFutures
import Foundation

public protocol HTTPRequestHandler {
    func handleRequest(_ urlRequest: URLRequest) -> Future<Data?, ServiceTransportError>
}
