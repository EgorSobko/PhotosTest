import UIKit
import Kit

extension PhotosListViewController {
    struct ViewState {
        
    }
}

class PhotosListViewController: UIViewController, KitchenDelegate {    

    // MARK: - Proeprties
    private(set) var viewState: ViewState?
    
    // MARK: - Private properties
    private var kitchen: AnyKitchen<PhotosListKitchen.ViewEvent, PhotosListKitchen.Command>!

    // MARK: - Methods
    func inject(kitchen: AnyKitchen<PhotosListKitchen.ViewEvent, PhotosListKitchen.Command>) {
        self.kitchen = kitchen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kitchen.receive(event: .viewDidLoad)
    }
    
    func perform(_ command: PhotosListKitchen.Command) {
        switch command {
        case .present(let viewState):
            self.viewState = viewState
        }
    }
}
