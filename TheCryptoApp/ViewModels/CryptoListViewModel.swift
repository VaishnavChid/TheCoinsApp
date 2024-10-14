
import Foundation

class CryptoListViewModel {
    
    // MARK: - Properties
    var dataModel: [DataResponseModel] = []
    var originalDataModel: [DataResponseModel] = []
    var activeFilters: [CryptoFilter] = []
    
    // MARK: - Fetch Data
    func fetchCryptoData(completion: @escaping (Result<[DataResponseModel], ErrorMessage>) -> Void) {
        NetworkService.getCryptoData { result in
            switch result {
            case .success(let successData):
                self.dataModel = successData
                self.originalDataModel = successData
                completion(.success(successData))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    // MARK: - Filtering
    func filterData(for searchText: String) {
        if searchText.isEmpty {
            dataModel = originalDataModel
        } else {
            dataModel = originalDataModel.filter { 
                $0.name?.localizedCaseInsensitiveContains(searchText) ?? false || 
                $0.symbol?.localizedCaseInsensitiveContains(searchText) ?? false 
            }
        }
    }
    
    func applyFilters() {
        dataModel = CryptoFilterModel.applyFilters(originalDataModel: originalDataModel, filters: activeFilters)
    }
}
