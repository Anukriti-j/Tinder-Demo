import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var name: String = ""
    @State private var mail: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationStack {
            
            ZStack(alignment: .center) {
                
                VStack(spacing: 20) {
                    Image(.soulmateLogo)
                        .resizable()
                        .frame(width: 200, height: 200)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        TextField("Name", text: $name)
                            .textFieldStyle(.roundedBorder)
                        
                        TextField("Email", text: $mail)
                            .textFieldStyle(.roundedBorder)
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    Button("SignUp") {
                        Task {
                            await viewModel.signUp(name: name, email: mail, password: password)
                        }
                    }
                    .padding()
                    .foregroundStyle(.black)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 4)
                    
                    NavigationLink("", destination: MainTabView(), isActive: $viewModel.isLoggedIn)
                        .hidden()
                    
                    if let error = viewModel.errorMessage {
                        Text(error).foregroundStyle(.red)
                    }
                    
                }
                .padding()
            }
        }
    }
}

#Preview {
    SignUpView()
}
