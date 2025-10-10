import Foundation

final class NetworkManager {
    static let service = NetworkManager()
    private init() {}
    
    func signUp(with requestData: SignUpRequest) async throws -> AuthResponse {
        guard let url = URL(string: "\(APIConstants.baseURL)/users/signup") else { throw NetworkErrors.invalidURL }
        return try await sendRequest(url: url, body: requestData)
    }
    
    func login(with requestData: LoginRequest) async throws -> AuthResponse {
        guard let url = URL(string: "\(APIConstants.baseURL)/auth/login") else { throw NetworkErrors.invalidURL }
        return try await sendRequest(url: url, body: requestData)
    }
    
    
    private func sendRequest<T: Codable>(url: URL, body: T) async throws -> AuthResponse {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkErrors.invalidResponse
        }
        
        if(200...299).contains(httpResponse.statusCode) {
            do {
                let decoded = try JSONDecoder().decode(AuthResponse.self, from: data)
                return decoded
            } catch {
                throw NetworkErrors.decodingError
            }
        } else {
            let message = String(data: data, encoding: .utf8) ?? "unknown error"
            throw NetworkErrors.serverError(message)
        }
    }
    
    
    
    
    
    //        func getDataFromAPI<T: Decodable>(from urlString: String, with param: [String: String]? = nil) async throws -> T {
    //            guard let url = URL(string: urlString) else {
    //                throw NetworkErrors.invalidURL }
    //
    //            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
    //            if let param = param {
    //                components?.queryItems = param.map { URLQueryItem(name: $0.key, value: $0.value)}
    //            }
    //
    //            guard let finalURL = components?.url else {
    //                throw NetworkErrors.invalidURL
    //            }
    //
    //            let (data, response) = try await URLSession.shared.data(from: finalURL)
    //
    //            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
    //                throw NetworkErrors.invalidResponse
    //            }
    //            do {
    //                let decoder = JSONDecoder()
    //                let decodedData = try decoder.decode(T.self, from: data)
    //                return decodedData
    //            } catch {
    //                throw NetworkErrors.decodingError
    //            }
    //        }
}
