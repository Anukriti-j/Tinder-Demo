import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var localNotificationManager: LocalNotificationManager
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationStack(path: $appState.path) {
            TabView {
                CardStackView()
                    .tabItem { Image(systemName: "flame") }
                    .tag(0)
                SearchView()
                    .tabItem { Image(systemName: "magnifyingglass") }
                    .tag(1)
                Text("Inbox View")
                    .tabItem { Image(systemName: "bubble") }
                    .tag(2)
                CurrentUserProfileView()
                    .tabItem { Image(systemName: "person") }
                    .tag(3)
            }
            .tint(.pink)
            .navigationDestination(for: User.self) { user in
                UserProfileView(user: user)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .didTapNotification)) { value in
            print("\(value)")
            guard
                let userInfo = value.userInfo,
                let userID = userInfo["userID"] as? String
            else {
                print("inside guard nil info")
                return }
            
            Task {
                if let user = await fetchUser(by: userID) {
                    await MainActor.run {
                        appState.selectedUser = user
                        appState.path.append(user)
                        print("\(appState.path)")
                        print("😉\(user)")
                    }
                }
            }
        }
    }
}

private extension MainTabView {
    func fetchUser(by id: String) async -> User? {
        print("fetching user with id ")
        for user in MockData.users {
            if user.id == id {
                print("\( user)❤️")
                return user
            }
        }
        return nil
    }
}

#Preview {
    MainTabView()
}
