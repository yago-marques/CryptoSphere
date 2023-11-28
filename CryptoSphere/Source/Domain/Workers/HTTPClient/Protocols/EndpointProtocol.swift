import Foundation

protocol EndpointProtocol {
    var urlBase: String { get set }
    var path: String { get set }
    var httpMethod: HTTPMethod { get set }
    var body: Data { get set }
    var headers: [String: String] { get set }
    var queries: [URLQueryItem] { get set }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

extension EndpointProtocol {
    func makeURL() -> URL? {
        guard var component = URLComponents(string: "\(urlBase)\(path)") else { return nil }
        component.scheme = "https"
        component.queryItems = queries.isEmpty ? nil : queries
        return component.url
    }

    func makeRequest() throws -> URLRequest {
        guard let url = self.makeURL() else {
            throw APICallError.invalidUrl
        }

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = self.headers
        request.httpMethod = self.httpMethod.rawValue

        return request
    }
}
