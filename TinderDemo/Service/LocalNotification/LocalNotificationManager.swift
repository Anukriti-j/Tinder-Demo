import Foundation
import UserNotifications
import SwiftUI

@MainActor
class LocalNotificationManager: NSObject , ObservableObject, UNUserNotificationCenterDelegate {
    private let notificationCenter = UNUserNotificationCenter.current()
    @Published var isGrantedNotification: Bool = false
    var appViewModel: AppViewModel?
    private var appState: AppViewModel?
    var onNotificationTap: (([AnyHashable: Any]) -> Void)? // Callback
    
    override init() {
        super.init()
    }
    
    func setAppState(_ state: AppViewModel) {
        appState = state
        notificationCenter.delegate = self
    }
    
    func requestAuthorization() async {
        do {
            try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
            await getCurrentSettings()
        } catch {
            print("error in requesting notification permission: \(error.localizedDescription)")
        }
    }
    
    func getCurrentSettings() async {
        let currentSettings = await notificationCenter.notificationSettings()
        isGrantedNotification = (currentSettings.authorizationStatus == .authorized)
        print(isGrantedNotification)
    }
    
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.sound, .banner, .list]
    }
    func scheduleBatchNotification(localNotification: LocalNotification) {
        print("notification scheduled")
        let content = UNMutableNotificationContent()
        content.title = localNotification.title
        content.body = localNotification.body
        content.userInfo = ["screen": "UserProfileView", "id": "123"]
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: localNotification.id, content: content, trigger: trigger) //localnotification.id to test
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("did receive response called")
//        if response .notification.request.identifier == {
//            DispatchQueue.main.async {
//                self.appViewModel?.navigateToUserDetail = true
//            }
//        }
        completionHandler()
    }
}
