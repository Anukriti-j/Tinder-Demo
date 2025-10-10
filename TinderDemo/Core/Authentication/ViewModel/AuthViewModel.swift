import Foundation

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var errorMessage: String?
    @Published var token: String? = nil
    @Published var user: APIUser?
    
    init() {
        if let savedToken = KeychainManager.getToken() {
            token = savedToken
            isLoggedIn = true
        }
    }
    
    func signUp(name: String, email: String, password: String) async {
        let request = SignUpRequest(username: name, password: password, email: email)
        do {
            let response = try await NetworkManager.service.signUp(with: request)
            self.user = response.user
            print(user?.username)
            isLoggedIn = true
        } catch {
            errorMessage = "\(error)"
            
        }
    }
    
    func login(name: String, password: String) async {
        let request = LoginRequest(username: name, password: password)
        do {
            let response = try await NetworkManager.service.login(with: request)
            self.user = response.user
            if let token = response.token {
                KeychainManager.saveToken(token)
            }
            print(response.response)
            isLoggedIn = true
        } catch {
            errorMessage = "\(error)"
        }
    }
    
    func checkIfLoggedIn() {
        if let _ = KeychainManager.getToken() {
            isLoggedIn = true
        }
    }
    
    func logout() {
        KeychainManager.deleteToken()
        self.user = nil
        isLoggedIn = false
    }
    
    func handleErrors(_ error: Error) -> String {
        switch error {
        case NetworkErrors.invalidURL:
            return "invalid url"
        case NetworkErrors.invalidResponse:
            return "Invalid server response"
        case NetworkErrors.decodingError:
            return "failed to decode data"
        case NetworkErrors.serverError(let message):
            return message
        default:
            return "something went wrong"
        }
        
    }
}

