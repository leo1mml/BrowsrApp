@testable
import Browsr_App
import Combine
import XCTest

class MockFetchOrganizationsUseCase: FetchOrganizationsUseCase {
    var result: Result<([Browsr_App.OrganizationListItemViewModel], String), Error>?

    func getOrganizations(customPath: String) -> AnyPublisher<([Browsr_App.OrganizationListItemViewModel], String), Error> {
        return result!.publisher.eraseToAnyPublisher()
    }
}

class MockSearchOrganizationsUseCase: SearchOrganizationsUseCase {
    var result: Result<Browsr_App.OrganizationListItemViewModel, Error>?
    
    func search(for term: String) -> AnyPublisher<OrganizationListItemViewModel, Error> {
        result!.publisher.eraseToAnyPublisher()
    }
}

class OrganizationListViewModelTests: XCTestCase {
    private var sut: OrganizationListViewModel!
    private var fetchOrganizationsUseCase: MockFetchOrganizationsUseCase!
    private var searchOrganizationsUseCase: MockSearchOrganizationsUseCase!
    private var cancellables: Set<AnyCancellable>!
    private let mainWaiter = XCTWaiter()
    
    override func setUp() {
        super.setUp()
        fetchOrganizationsUseCase = MockFetchOrganizationsUseCase()
        searchOrganizationsUseCase = MockSearchOrganizationsUseCase()
        sut = OrganizationListViewModel(fetchOrganizationsUseCase: fetchOrganizationsUseCase,
                                        searchOrganizationsUseCase: searchOrganizationsUseCase)
        cancellables = []
    }
    
    func testGetOrganizations_when_success_hasTo_sendData() {
        fetchOrganizationsUseCase.result = .success(([
            OrganizationListItemViewModel(id: 1231, name: "Test", description: "Noice organization", imageURL: nil)
        ], ""))
        let expectation = XCTestExpectation(description: "receives data")
        var result: [OrganizationListItemViewModel]?
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
        mainWaiter.wait(for: [expectation], timeout: 2)
        XCTAssertNil(error)
        XCTAssertNotNil(result)
        XCTAssert(!result!.isEmpty)
    }
    
    func testGetOrganizations_when_fails_hasTo_sendError() {
        fetchOrganizationsUseCase.result = .failure(URLError(.badServerResponse))
        let expectation = XCTestExpectation(description: "receives error")
        var result: String?
        sut.$errorMessage.sink { _ in
            expectation.fulfill()
        } receiveValue: { orgs in
            result = orgs
        }.store(in: &cancellables)
        sut.getOrganizations()
        mainWaiter.wait(for: [expectation], timeout: 2)
        XCTAssertNotNil(result)
    }
    
    func testFilter_when_hasSubset_hasTo_showValues() {
        let expectation = XCTestExpectation(description: "fetched data")
        makeInitalFetch(expectation: expectation)
        mainWaiter.wait(for: [expectation], timeout: 2)
        var filteredValue: [OrganizationListItemViewModel] = []
        let expectFilter = XCTestExpectation(description: "filtered data")
        sut.$organizations.sink { _ in
            expectFilter.fulfill()
        } receiveValue: { values in
            filteredValue = values
        }.store(in: &cancellables)
        sut.filterCurrentItems(by: "ing")
        let filterWaiter = XCTWaiter()
        filterWaiter.wait(for: [expectFilter], timeout: 2)
        XCTAssert(filteredValue.count == 1)
    }
    
    func testSearch_when_findItems_hasTo_showResults() {
        let result = OrganizationListItemViewModel(id: 12, name: "Testing", description: "Nice", imageURL: "someimage")
        fetchOrganizationsUseCase.result = .success(([], ""))
        searchOrganizationsUseCase.result = .success(result)
        let searchWaiter = XCTWaiter()
        let expectToFetchSearchItems = XCTestExpectation()
        var results: [OrganizationListItemViewModel] = []
        sut.$organizations.sink { _ in
            expectToFetchSearchItems.fulfill()
        } receiveValue: { orgs in
            results = orgs
        }.store(in: &cancellables)
        sut.search(by: "ing")
        searchWaiter.wait(for: [expectToFetchSearchItems], timeout: 2)
        XCTAssertFalse(results.isEmpty)
    }
}

private extension OrganizationListViewModelTests {
    
    func makeInitalFetch(expectation: XCTestExpectation) {
        
        let superSet = [
            OrganizationListItemViewModel(id: 32, name: "Test", description: "Noooice", imageURL: "myimage"),
            OrganizationListItemViewModel(id: 12, name: "Testing", description: "Nice", imageURL: "someimage")
        ]
        fetchOrganizationsUseCase.result = .success((superSet, " "))
        
        sut.$organizations.sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(_):
                XCTFail()
            }
            expectation.fulfill()
        } receiveValue: { _ in }.store(in: &cancellables)
        sut.getOrganizations()
    }
}
