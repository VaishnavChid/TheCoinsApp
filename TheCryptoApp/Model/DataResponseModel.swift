
import Foundation

struct DataResponseModel: Codable {
    
    var name: String?
    var symbol: String?
    var isNew: Bool = false
    var isActive: Bool = false
    var type: CurrencyType?

    enum CodingKeys: String, CodingKey {
        case name, symbol, type
        case isNew = "is_new"
        case isActive = "is_active"
    }
    
    enum CurrencyType: String, Codable {
        case coin, token
    }
    
}

