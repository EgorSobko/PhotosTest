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
        static let minCellHeight: CGFloat = 70
    }
    
    // MARK: - Private outlets
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            let cellNib = UINib(nibName: Constant.photoCellIdentifier, bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: Constant.photoCellIdentifier)
            
            tableView.dataSource = self
            tableView.delegate = self
            tableView.estimatedRowHeight = UITableView.automaticDimension
        }
    }
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private(set) var viewState: ViewState?
    
    // MARK: - Private properties
    private var kitchen: AnyKitchen<PhotosListKitchen.ViewEvent, PhotosListKitchen.Command>!
    private var router: PhotosListRoutable!
    
    // MARK: - Methods
    func inject(kitchen: AnyKitchen<PhotosListKitchen.ViewEvent, PhotosListKitchen.Command>, router: PhotosListRoutable) {
        self.kitchen = kitchen
        self.router = router
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kitchen.receive(event: .viewDidLoad)
    }
    
    func perform(_ command: PhotosListKitchen.Command) {
        switch command {
        case .present(let viewState):
            self.viewState = viewState
            tableView.reloadData()
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

extension PhotosListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewState?.cellViewStates.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.photoCellIdentifier, for: indexPath) as? PhotoTableViewCell,
            let cellViewState = viewState?.cellViewStates[indexPath.row] else {
                return UITableViewCell()
        }
        
        cell.configure(with: cellViewState)
        
        return cell
    }
}

extension PhotosListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.minCellHeight
    }
}
