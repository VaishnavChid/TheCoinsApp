
enum CryptoFilter {
    case active
    case inactive
    case coin
    case token
    case new
}

struct CryptoFilterModel {
    
    static func applyFilters(originalDataModel: [DataResponseModel], filters: [CryptoFilter]) -> [DataResponseModel] {
        return originalDataModel.filter { crypto in
            var isMatching = true
            
            filters.forEach { filter in
                switch filter {
                case .active:
                    isMatching = isMatching && (crypto.isActive)
                case .inactive:
                    isMatching = isMatching && (!crypto.isActive)
                case .coin:
                    isMatching = isMatching && (crypto.type == .coin)
                case .token:
                    isMatching = isMatching && (crypto.type == .token)
                case .new:
                    isMatching = isMatching && (crypto.isNew)
                }
            }
            return isMatching
        }
    }
    
}
