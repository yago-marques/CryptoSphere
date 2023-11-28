import Foundation

final class URLSessionHTTPClient: HTTPClient {

    let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func request(endpoint: EndpointProtocol) async throws -> Data? {
        do {
            let request = try endpoint.makeRequest()

            let (data, response) = try await session.data(for: request)

            guard let response = response as? HTTPURLResponse else { return nil }
            switch response.statusCode {
            case 200..<300:
                return data
            default:
                throw APICallError.invalidResponse
            }
        } catch {
            throw error
        }
    }
}
