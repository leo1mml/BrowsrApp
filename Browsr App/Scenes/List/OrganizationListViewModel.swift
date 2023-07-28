import Foundation
import Combine

class OrganizationListViewModel: ObservableObject {
    @Published
    var organizations: [OrganizationListItemViewModel] = []
    private var fetchedOrganizations: [OrganizationListItemViewModel] = []
    @Published
    var errorMessage: String?
    @Published
    var canLoadNextPage = false
    private var cancellables: Set<AnyCancellable> = .init()
    private var fetchOrganizationsUseCase: FetchOrganizationsUseCase
    private let searchOrganizationsUseCase: SearchOrganizationsUseCase
    private var nextPagePath: String = ""
    var isFetching = false
    
    init(fetchOrganizationsUseCase: FetchOrganizationsUseCase,
         searchOrganizationsUseCase: SearchOrganizationsUseCase) {
        self.fetchOrganizationsUseCase = fetchOrganizationsUseCase
        self.searchOrganizationsUseCase = searchOrganizationsUseCase
    }

    func getOrganizations() {
        let publisher = fetchOrganizationsUseCase.getOrganizations(customPath: nextPagePath)
            .receive(on: RunLoop.main)
            .map { [weak self] (orgs, path) in
                self?.isFetching = false
                let currentPagePath = self?.nextPagePath
                self?.nextPagePath = self?.formatPath(path: path) ?? ""
                self?.canLoadNextPage = !(self?.nextPagePath.isEmpty ?? true) && self?.nextPagePath != currentPagePath
                return orgs
            }
            .compactMap{ $0 }
            .eraseToAnyPublisher()
        consumeOrganizationsPublisher(publisher)
    }
    
    private func formatPath(path: String) -> String {
        guard !path.isEmpty else { return path }
        let url = path.components(separatedBy: ";").first ?? ""
        let param = url.split(separator: "?").last?.dropLast(1) ?? ""
        return "?" + "\(param)"
    }
    
    func search(by text: String) {
        let publisher = searchOrganizationsUseCase.search(for: text)
            .map {
                [$0]
            }.eraseToAnyPublisher()
        consumeOrganizationsPublisher(publisher)
    }
    
    private func consumeOrganizationsPublisher(_ publisher: AnyPublisher<[OrganizationListItemViewModel], Error>) {
        if isFetching {
            return
        }
        isFetching = true
        publisher
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                self?.isFetching = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.handle(error)
                }
            } receiveValue: { [weak self] orgs in
                self?.organizations += orgs
                self?.fetchedOrganizations += orgs
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

