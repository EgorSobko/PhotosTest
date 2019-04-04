import Foundation

public struct OperationConfiguration {
    let host: String?
    let resource: String
    let method: HTTPMethod
    
    init(host: String? = nil, resource: String, method: HTTPMethod) {
        self.host = host
        self.resource = resource
        self.method = method
    }
}
