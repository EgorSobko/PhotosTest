import Foundation
import Api
import Kit

extension AddPhotoKitchen {
    enum ViewEvent {
        
    }
    
    enum Command {
       
    }
}

class AddPhotoKitchen: Kitchen {
    
    // MARK: - Properties
    weak var delegate: AnyKitchenDelegate<Command>?
    
    // MARK: - Private properties
    private let viewStateFactory: PhotosListViewStateFactory
    private let photosService: PhotosService
    
    // MARK: - Init
    init(viewStateFactory: PhotosListViewStateFactory, photosService: PhotosService) {
        self.viewStateFactory = viewStateFactory
        self.photosService = photosService
    }
    
    // MARK: - Methods
    func receive(event: AddPhotoKitchen.ViewEvent) {
        
    }
    
    // MARK: - Private methods
    private func handleViewDidLoad() {
        
    }
}
