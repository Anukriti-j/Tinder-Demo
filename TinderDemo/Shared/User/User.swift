import Foundation

struct User: Identifiable, Hashable {
    let id: String
    let fullName: String
    let age: Int
    let bio: String?
    let profileImageURLs: [String]
}
