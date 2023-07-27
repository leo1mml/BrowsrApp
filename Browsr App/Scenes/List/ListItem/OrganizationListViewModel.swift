import Foundation
import Combine

class OrganizationListViewModel: ObservableObject {
    @Published
    var organizations: [OrganizationListItemViewModel] = []
    var fetchedOrganizations: [OrganizationListItemViewModel] = []
    @Published
    var errorMessage: String?
    private var cancellables: Set<AnyCancellable> = .init()
    private var fetchOrganizationsUseCase: FetchOrganizationsUseCase
    
    init(fetchOrganizationsUseCase: FetchOrganizationsUseCase) {
        self.fetchOrganizationsUseCase = fetchOrganizationsUseCase
    }

    func getOrganizations() {
        fetchOrganizationsUseCase.getOrganizations()
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.handle(error)
                }
            } receiveValue: { [weak self] orgs in
                self?.organizations = orgs
                self?.fetchedOrganizations = orgs
            }.store(in: &cancellables)
    }
    
    func search(by text: String) {
        
    }
    
    func filterCurrentItems(by term: String) {
        if term.isEmpty {
            organizations = fetchedOrganizations
        } else {
            organizations = fetchedOrganizations.filter { $0.name.contains(term.lowercased()) }
        }
    }
    
    private func handle(_ error: Error) {
        switch error {
        case is URLError:
            errorMessage = "Please try again in a moment, we're experiencing some problems"
        default:
            errorMessage = "Please try again later, well be back in a moment"
        }
    }
}

