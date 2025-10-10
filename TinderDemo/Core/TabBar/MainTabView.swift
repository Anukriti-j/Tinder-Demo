import SwiftUI

struct MainTabView: View {
    @StateObject var appViewModel: AppViewModel = AppViewModel()
    @EnvironmentObject var localNotificationManager: LocalNotificationManager
    
    var body: some View {
        NavigationStack {
            TabView {
                CardStackView()
                    .tabItem { Image(systemName: "flame") }
                    .tag(0)
                SignUpView()
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
            .navigationDestination(isPresented: $appViewModel.navigateToUserDetail) {
                UserProfileView(user: MockData.users[1])
            }
        }
        .onAppear {
            localNotificationManager.appViewModel = appViewModel
            Task {
                await  localNotificationManager.requestAuthorization()
            }
        }
    }
}

#Preview {
    MainTabView()
}
