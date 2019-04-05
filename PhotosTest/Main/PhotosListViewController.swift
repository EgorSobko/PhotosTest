import UIKit
import Kit

extension PhotosListViewController {
    struct ViewState {
        let cellViewStates: [PhotoTableViewCell.ViewState]
    }
}

class PhotosListViewController: UIViewController, KitchenDelegate {    

    private enum Constant {
        static let photoCellIdentifier = String(describing: PhotoTableViewCell.self)
    }
    // MARK: - Private outlets
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            let cellNib = UINib(nibName: Constant.photoCellIdentifier, bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: Constant.photoCellIdentifier)
        }
    }
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: - Properrties
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
        case .presentError(let title, let description):
            handlePresentError(withTitle: title, description: description)
        case .startLoading:
            loadingIndicator.isHidden = false
            tableView.isHidden = true
        case .stopLoading:
            loadingIndicator.isHidden = true
            tableView.isHidden = false
        }
    }
    
    // MARK: - Private methods
    private func handlePresentError(withTitle title: String, description: String) {
        let alertViewController = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertViewController.addAction(okAction)
        
        present(alertViewController, animated: true, completion: nil)
    }
}
