import Foundation
import SwiftUI

@MainActor
class AppState: ObservableObject {
    static let shared = AppState()
    @Published var path = NavigationPath()
    @Published var selectedUser : User? = nil
}
