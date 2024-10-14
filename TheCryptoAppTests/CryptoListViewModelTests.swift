
import XCTest
@testable import TheCryptoApp

class CryptoListViewModelTests: XCTestCase {
    var viewModel: CryptoListViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = CryptoListViewModel()
    }
    
    func testFetchCryptoDataSuccess() {
        let expectation = XCTestExpectation(description: "Fetch crypto data")
        
        viewModel.fetchCryptoData { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data.count, 26)
                XCTAssertNotNil(self.viewModel.dataModel)
                XCTAssertEqual(self.viewModel.dataModel.first?.symbol, "BTC")
            case .failure:
                XCTFail("Expected success, but got failure")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchCryptoDataFailure() {
        let expectation = XCTestExpectation(description: "Fetch crypto data failure")
        
        let mockNetworkService = MockNetworkService()
        let viewModel = CryptoListViewModel(networkService: mockNetworkService)
        
        viewModel.fetchCryptoData { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error, .invalidResponse)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}

// MARK: - Mock service for testing
class MockNetworkService: NetworkServiceProtocol {
    func getCryptoData(completion: @escaping (Result<[DataResponseModel], ErrorMessage>) -> Void) {
        completion(.failure(.invalidResponse))
    }
}
