import UIKit
import Kit

extension AddPhotoViewController {
    struct ViewState {
        
    }
}

class AddPhotoViewController: UIViewController, KitchenDelegate {
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var photoTitleDescriptionLabel: UILabel!
    @IBOutlet private weak var photoTitleDescriptionTextField: UITextField!
    @IBOutlet private weak var albumTitleDescriptionLabel: UILabel!
    @IBOutlet private weak var albumTitlesTableView: UITableView!
    @IBOutlet private weak var submitButton: UIButton!
    
    // MARK: - Properties
    private(set) var viewState: ViewState?
    
    // MARK: - Private properties
    private var kitchen: AnyKitchen<AddPhotoKitchen.ViewEvent, AddPhotoKitchen.Command>!
    
    // MARK: - Methods
    func inject(kitchen: AnyKitchen<AddPhotoKitchen.ViewEvent, AddPhotoKitchen.Command>) {
        self.kitchen = kitchen
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        if newCollection.verticalSizeClass == .compact {
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
        } else {
            stackView.axis = .vertical
            stackView.distribution = .fill
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func perform(_ command: AddPhotoKitchen.Command) {
        
    }
    
    // MARK: - Private methods
    
}

extension AddPhotoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension AddPhotoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
}
