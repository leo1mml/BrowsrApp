import Browsr_Lib
import Combine

class BrowsrApiFetchOrganizationUseCase: FetchOrganizationsUseCase {
    
    private let lib: BrowsrLib
    
    init(lib: BrowsrLib) {
        self.lib = lib
    }
    
    func getOrganizations() -> AnyPublisher<[Organization], Error> {
        let pub = lib.getOrganizations()
            .map {
                $0.map { org in
                    Organization(id: org.id,
                                 name: org.login,
                                 description: org.description,
                                 imageURL: org.avatarURL)
                }
            }.eraseToAnyPublisher()
        return pub
    }
}
