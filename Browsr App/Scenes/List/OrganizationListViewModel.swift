import Foundation
import Combine

class OrganizationListViewModel: ObservableObject {
    @Published
    var organizations: [Organization] = []
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
            }.store(in: &cancellables)
    }
    
    private func handle(_ error: Error) {}
}

struct Organization {
    let id: Int
    let name: String
    let description: String?
    let imageURL: String?
}
