import Combine

protocol FetchOrganizationsUseCase {
    func getOrganizations() -> AnyPublisher<[OrganizationListItemViewModel], Error>
}
