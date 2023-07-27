import Browsr_Lib
import Foundation
import Combine

class BrowserApiSearchOrganizationsUseCase: SearchOrganizationsUseCase {
    
    private let lib: BrowsrLib
    
    init(lib: BrowsrLib) {
        self.lib = lib
    }
    
    func search(for term: String) -> AnyPublisher<OrganizationListItemViewModel, Error> {
        return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
    }
}
