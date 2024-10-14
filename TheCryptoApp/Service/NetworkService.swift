
import Foundation

struct NetworkService {
    
    static func getCryptoData(completion: @escaping (Result<[DataResponseModel], ErrorMessage>) -> Void) {
        performRequest(endpoint: .getData) { result in
            switch result {
            case .success(let apiResponse):
                completion(.success(apiResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Private helper method
    
    static func performRequest(endpoint: EndPoints, completion: @escaping(Result<[DataResponseModel], ErrorMessage>) -> Void) {
        URLSession.shared.dataTask(with: endpoint.url) { data, response, error in
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode([DataResponseModel].self, from: data)
                completion(.success(apiResponse))
            } catch {
                completion(.failure(.invalidData))
            }
        }.resume()
    }
    
}
