import Foundation

enum APICallError: Error {
    case invalidUrl
    case network(Error)
    case invalidAuth
    case invalidResponse
    case httpError(code: Int)
}
