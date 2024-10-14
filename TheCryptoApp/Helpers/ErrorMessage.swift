
import Foundation

enum ErrorMessage: String, Error {
    
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
    case needsApiKey = "Needs API key in order to fetch coins from API."
    
}
