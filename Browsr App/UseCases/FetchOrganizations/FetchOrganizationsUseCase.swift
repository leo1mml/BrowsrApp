import Combine

protocol FetchOrganizationsUseCase {
    func getOrganizations() -> AnyPublisher<[Organization], Error>
}
