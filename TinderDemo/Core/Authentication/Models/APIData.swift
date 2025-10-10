
import Foundation

struct AuthResponse: Codable {
    let response: String?
    let user: APIUser?
    let token: String?
}

// MARK: - User
struct APIUser: Codable {
    let username: String
    let id: Int
    let email: String
}

struct LoginRequest: Codable {
    let username, password: String
}

struct SignUpRequest: Codable {
    let username: String
    let password: String
    let email: String
}


