import BrowsrLib
import Foundation
import Combine

class BrowserApiSearchOrganizationsUseCase: SearchOrganizationsUseCase {
    
    private let lib: BrowsrLib
    
    init(lib: BrowsrLib) {
        self.lib = lib
    }
    
    func search(for term: String) -> AnyPublisher<OrganizationListItemViewModel, Error> {
        lib.searchOrganization(by: term)
            .map { org in
                OrganizationListItemViewModel(id: org.id,
                                              name: org.login,
                                              description: org.description,
                                              imageURL: org.avatarURL)
            }
            .eraseToAnyPublisher()
    }
}
