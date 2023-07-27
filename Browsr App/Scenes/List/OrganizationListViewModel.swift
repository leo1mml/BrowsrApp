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
    private let searchOrganizationsUseCase: SearchOrganizationsUseCase
    
    init(fetchOrganizationsUseCase: FetchOrganizationsUseCase,
         searchOrganizationsUseCase: SearchOrganizationsUseCase) {
        self.fetchOrganizationsUseCase = fetchOrganizationsUseCase
        self.searchOrganizationsUseCase = searchOrganizationsUseCase
    }

    func getOrganizations() {
        let publisher = fetchOrganizationsUseCase.getOrganizations()
        consumeOrganizationsPublisher(publisher)
    }
    
    func search(by text: String) {
        let publisher = searchOrganizationsUseCase.search(for: text)
        consumeOrganizationsPublisher(publisher)
    }
    
    private func consumeOrganizationsPublisher(_ publisher: AnyPublisher<[OrganizationListItemViewModel], Error>) {
        publisher
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

