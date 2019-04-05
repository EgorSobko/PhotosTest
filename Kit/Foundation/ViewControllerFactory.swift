import Foundation
import UIKit

public class ViewControllerFactory {
    
    public init() { }
    
    public func createViewController<T: UIViewController>(type: T.Type, storyboardName: String, storyboardIdentifer: String) -> T {
        let bundle = Bundle(for: T.self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifer) as! T
    }
}
