import SwiftUI

@main
struct TinderDemoApp: App {
    @StateObject private var localNotificationManager = LocalNotificationManager()
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isLoggedIn {
                MainTabView()
                    .environmentObject(localNotificationManager)
                    .environmentObject(authViewModel)
            } else {
                LoginView()
                    .environmentObject(localNotificationManager)
                    .environmentObject(authViewModel)
            }
        }
    }
}

// creating loading indicator
// create cover to blank screen
// add - block and report user in user profile page

