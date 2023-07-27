@testable
import Browsr_App
import Combine
import XCTest

class MockFetchOrganizationsUseCase: FetchOrganizationsUseCase {
    var result: Result<[Browsr_App.Organization], Error>?
    func getOrganizations() -> AnyPublisher<[Browsr_App.Organization], Error> {
        return result!.publisher.eraseToAnyPublisher()
    }
}

class OrganizationListViewModelTests: XCTestCase {
    private var sut: OrganizationListViewModel!
    private var fetchOrganizationsUseCase: MockFetchOrganizationsUseCase!
    private var cancellables: Set<AnyCancellable>!
    private let waiter = XCTWaiter()
    
    override func setUp() {
        super.setUp()
        fetchOrganizationsUseCase = MockFetchOrganizationsUseCase()
        sut = OrganizationListViewModel(fetchOrganizationsUseCase: fetchOrganizationsUseCase)
        cancellables = []
    }
    
    func testGetOrganizations_when_success_hasTo_sendData() {
        fetchOrganizationsUseCase.result = .success([
            Organization(id: 1231, name: "Test", imageURL: nil)
        ])
        let expectation = XCTestExpectation(description: "receives data")
        var result: [Organization]?
        var error: Error?
        sut.$organizations.sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let err):
                error = err
            }
            expectation.fulfill()
        } receiveValue: { orgs in
            result = orgs
        }.store(in: &cancellables)
        sut.getOrganizations()
        waiter.wait(for: [expectation], timeout: 2)
        XCTAssertNil(error)
        XCTAssertNotNil(result)
        XCTAssert(!result!.isEmpty)
    }
}
