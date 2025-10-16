import SwiftUI
import SwiftData

@main
struct TinderDemoApp: App {
    @StateObject private var localNotificationManager = LocalNotificationManager()
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var appState = AppState.shared
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isLoggedIn {
                MainTabView()
                    .environmentObject(localNotificationManager)
                    .environmentObject(authViewModel)
                    .environmentObject(appState)
                    .onAppear {
                        Task {
                            await localNotificationManager.requestAuthorization()
                        }
                    }
            } else {
                LoginView()
                    .environmentObject(localNotificationManager)
                    .environmentObject(authViewModel)
                    .environmentObject(appState)
            }
        }
        .modelContainer(for: ProfileImageModel.self)
    }
}

// creating loading indicator
// create cover to blank screen
// add - block and report user in user profile page

