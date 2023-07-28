import Combine

protocol FetchOrganizationsUseCase {
    func getOrganizations(customPath: String) -> AnyPublisher<([OrganizationListItemViewModel], String), Error>
}
