import SwiftUI

struct SearchView: View {
    @State var searchUser: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredUsers) { user in
                    NavigationLink {
                        UserProfileView(user: user)
                    } label: {
                        HStack {
                            if let firstImageURL = user.profileImageURLs.first {
                                Image("\(user.profileImageURLs[0])")
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 50, height: 50)
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                            }
                            Text(user.fullName)
                                .font(.subheadline)
                        }
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .searchable(text: $searchUser)
            .listStyle(.plain)
        }
    }
}

private extension SearchView {
    var filteredUsers: [User] {
        if searchUser.isEmpty {
            return MockData.users
        } else {
            return MockData.users.filter { user in
                user.fullName.localizedCaseInsensitiveContains(searchUser)
            }
        }
    }
}

#Preview {
    SearchView()
}
