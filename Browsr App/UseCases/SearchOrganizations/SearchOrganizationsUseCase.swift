import Combine

protocol SearchOrganizationsUseCase {
    func search(for term: String) -> AnyPublisher<[OrganizationListItemViewModel], Error>
}
