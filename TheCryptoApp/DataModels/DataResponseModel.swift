
import Foundation

struct DataResponseModel: Codable {
    
    var name: String?
    var symbol: String?
    var isNew: Bool = false
    var isActive: Bool = false
    var type: CryptoType?

    enum CodingKeys: String, CodingKey {
        case name, symbol, type
        case isNew = "is_new"
        case isActive = "is_active"
    }
    
    enum CryptoType: String, Codable {
        case coin, token
    }
    
}

