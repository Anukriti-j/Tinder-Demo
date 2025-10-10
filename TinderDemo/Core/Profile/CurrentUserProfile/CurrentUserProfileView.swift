import SwiftUI

struct CurrentUserProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showEditProfile: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                CurrentUserProfileHeaderView(user: authViewModel.user ?? nil)
                    .onTapGesture { showEditProfile.toggle() }
                
                Section("Account Information") {
                    HStack {
                        Text("Name")
                        Spacer()
                        Text(authViewModel.user?.username ?? "Unknown")
                    }
                    HStack {
                        Text("Email")
                        Spacer()
                        Text("test@gmail.com")
                    }
                }
                
                Section("Legal") {
                    Text("Terms of Service")
                }
                
                Section {
                    Button("Logout") {
                        authViewModel.logout()
                    }
                    .foregroundStyle(.red)
                }
                
                Section {
                    Button("Delete Account") {
                        print("Debug: Delete account here...")
                    }
                    .foregroundStyle(.red)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $showEditProfile) {
                EditProfileView(user: MockData.users[0])
            }

        }
    }
}

//#Preview {
//    CurrentUserProfileView(user: MockData.users[1])
//}
