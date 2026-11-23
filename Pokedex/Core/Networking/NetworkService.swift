import Foundation

protocol APIEndpoint: Sendable {
    var baseURL: String { get }
    var path: String { get }
    var method: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension APIEndpoint {
    var queryItems: [URLQueryItem] { [] }
}

protocol NetworkService: Sendable {
    func request<T: Decodable & Sendable>(
        endpoint: any APIEndpoint,
        responseType: T.Type
    ) async throws -> T
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case httpStatus(Int)
}

struct URLSessionNetworkService: NetworkService {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Decodable & Sendable>(
        endpoint: any APIEndpoint,
        responseType: T.Type
    ) async throws -> T {
        guard let baseURL = URL(string: endpoint.baseURL),
              var components = URLComponents(
                url: baseURL.appendingPathComponent(endpoint.path),
                resolvingAgainstBaseURL: false
              ) else {
            throw NetworkError.invalidURL
        }

        if !endpoint.queryItems.isEmpty {
            components.queryItems = endpoint.queryItems
        }

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method

        let (data, response) = try await session.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200..<300).contains(response.statusCode) else {
            throw NetworkError.httpStatus(response.statusCode)
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(responseType, from: data)
    }
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Некорректный адрес запроса."
        case .invalidResponse:
            return "Не удалось прочитать ответ сервера."
        case .httpStatus(let code):
            return "Сервер вернул ошибку \(code)."
        }
    }
}
