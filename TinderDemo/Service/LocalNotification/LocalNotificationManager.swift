import Foundation
import UserNotifications
import SwiftUI

@MainActor
class LocalNotificationManager: NSObject , ObservableObject, UNUserNotificationCenterDelegate {
    private let notificationCenter = UNUserNotificationCenter.current()
    @Published var isGrantedNotification: Bool = false
    @Published var selectedUser: User? = nil
    var onNotificationTap: (([AnyHashable: Any]) -> Void)? // Callback
    
    override init() {
        super.init()
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
    
    func scheduleBatchNotification(user: User) {
        print("notification scheduled")
        let content = UNMutableNotificationContent()
        content.title = "Liked ❤️: \(user.fullName)"
        content.body = "Visit Profile"
        content.userInfo = ["userID": user.id]
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: user.id, content: content, trigger: trigger) //localnotification.id to test
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("did receive response called")
        let userID = response.notification.request.content.userInfo["userID"] as? String

        if let id = userID {
            NotificationCenter.default.post(name: .didTapNotification, object: nil, userInfo: ["userID": id])
        }
        completionHandler()
    }
}
