import BrowsrLib
import Combine

class BrowsrApiFetchOrganizationUseCase: FetchOrganizationsUseCase {
    
    private let lib: BrowsrLib
    
    init(lib: BrowsrLib) {
        self.lib = lib
    }
    
    func getOrganizations(customPath: String) -> AnyPublisher<([OrganizationListItemViewModel], String), Error> {
        let pub = lib.getOrganizations(customPath: customPath)
            .map { (orgs, nextURL) in
                let items = orgs.map { org in
                    OrganizationListItemViewModel(id: org.id,
                                                  name: org.login,
                                                  description: org.description,
                                                  imageURL: org.avatarURL)
                }
                return (items, nextURL)
                
            }.eraseToAnyPublisher()
        return pub
    }
}
