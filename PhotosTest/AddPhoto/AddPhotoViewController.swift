import UIKit
import Kit

extension AddPhotoViewController {
    struct ViewState {
        struct Title {
            let description: String
            let isSelected: Bool
        }
        
        let photoTitleDescription: String
        let albumTitleDescription: String
        let submitButtonTitle: String
        let availableTitles: [Title]
    }
}

class AddPhotoViewController: UIViewController, KitchenDelegate {
    
    private enum Constant {
        static let defaultCellIdentifier = "defaultCellIdentifier"
    }
    
    // MARK: - Private outlets
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var photoTitleDescriptionLabel: UILabel!
    @IBOutlet private weak var photoTitleDescriptionTextField: UITextField!
    @IBOutlet private weak var albumTitleDescriptionLabel: UILabel!
    @IBOutlet private weak var albumTitlesTableView: UITableView! {
        didSet {
            albumTitlesTableView.dataSource = self
            albumTitlesTableView.delegate = self
        }
    }
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private(set) var viewState: ViewState?
    
    // MARK: - Private properties
    private var kitchen: AnyKitchen<AddPhotoKitchen.ViewEvent, AddPhotoKitchen.Command>!
    private var photoTitleTextFormatter: TextFormatter!
    
    // MARK: - Methods
    func inject(kitchen: AnyKitchen<AddPhotoKitchen.ViewEvent, AddPhotoKitchen.Command>, photoTitleTextFormatter: TextFormatter) {
        self.kitchen = kitchen
        self.photoTitleTextFormatter = photoTitleTextFormatter
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
        
        setupTextField()
        kitchen.receive(event: .viewDidLoad)
    }
    
    func perform(_ command: AddPhotoKitchen.Command) {
        switch command {
        case .present(let viewState):
            apply(viewState)
        case .presentError(let title, let description):
            handlePresentError(withTitle: title, description: description)
        case .startLoadingTitles:
            loadingIndicator.isHidden = false
            albumTitlesTableView.isHidden = true
        case .stopLoadingTitles:
            loadingIndicator.isHidden = true
            albumTitlesTableView.isHidden = false
        case .resignFirstResponder:
            view.endEditing(true)
        }
    }
    
    // MARK: - Private methods
    private func setupTextField() {
        photoTitleDescriptionTextField.delegate = self
        photoTitleDescriptionTextField.addTarget(self, action: #selector(photoTitleDidChange), for: .editingChanged)
    }
    
    private func apply(_ viewState: ViewState) {
        self.viewState = viewState
        
        photoTitleDescriptionLabel.text = viewState.photoTitleDescription
        albumTitleDescriptionLabel.text = viewState.albumTitleDescription
        submitButton.setTitle(viewState.submitButtonTitle, for: .normal)
        
        if !viewState.availableTitles.isEmpty {
            albumTitlesTableView.reloadData()
        }
    }
    
    private func handlePresentError(withTitle title: String, description: String) {
        let alertViewController = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertViewController.addAction(okAction)
        
        present(alertViewController, animated: true, completion: nil)
    }
    
    @objc private func handleDone() {
        
    }
    
    @objc private func photoTitleDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        
        photoTitleDescriptionTextField.text = photoTitleTextFormatter.formatText(text)
    }
    
    @IBAction private func submit() {
        kitchen.receive(event: .submit(photoTitle: photoTitleDescriptionTextField.text ?? ""))
    }
}

extension AddPhotoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewState?.availableTitles.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let title = viewState?.availableTitles[indexPath.row] else {
            return UITableViewCell()
        }
        
        let cell: UITableViewCell
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: Constant.defaultCellIdentifier) {
            cell = dequeuedCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: Constant.defaultCellIdentifier)
        }
        
        cell.textLabel?.text = title.description
        cell.accessoryType = title.isSelected ? .checkmark : .none
        
        return cell
    }
}

extension AddPhotoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        kitchen.receive(event: .didSelectRow(atIndex: indexPath.row))
    }
}

extension AddPhotoViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        kitchen.receive(event: .submit(photoTitle: textField.text ?? ""))
        
        return true
    }
}
