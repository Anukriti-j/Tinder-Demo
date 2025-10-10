import Foundation

struct MockData {
    static let users: [User] = [
        .init(
            id: UUID().uuidString,
            fullName: "Tushar",
            age: 22, bio: "Engineer | Memer | Writer",
            profileImageURLs: [
                "Tushar-1"
            ]
        ),
        .init(
            id: UUID().uuidString,
            fullName: "Anukriti",
            age: 22, bio: "Engineer | Writer | Artist",
            profileImageURLs: [
                "Anukriti-1",
                "Anukriti-2"
            ]
        ),
        .init(
            id: UUID().uuidString,
            fullName: "Sizuka",
            age: 18, bio: "Princess",
            profileImageURLs: [
                "sizuka-1",
                "sizuka-2"
            ]
        ),
        .init(
            id: UUID().uuidString,
            fullName: "Sakua",
            age: 23, bio: "CEO Google",
            profileImageURLs: [
                "sakua-1",
                "sakua-2"
            ]
        )
    ]
    
}
