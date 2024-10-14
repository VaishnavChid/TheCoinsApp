
enum CryptoFilter: String {
    case active = "Active Coins"
    case inactive = "Inactive Coins"
    case coin = "Only Coins"
    case token = "Only Tokens"
    case new = "New Coins"
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
