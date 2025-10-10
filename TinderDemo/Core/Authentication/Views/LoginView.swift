import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var viewModel: AuthViewModel
    @State private var name: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationStack {
            
            ZStack(alignment: .center) {
                
                VStack(spacing: 24) {
                    Image(.soulmateLogo)
                        .resizable()
                        .frame(width: 200, height: 200)
                    
                    VStack(alignment: .leading, spacing: 24) {
                        TextField("Name", text: $name)
                            .textFieldStyle(.roundedBorder)
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    Button("Login") {
                        Task {
                            await viewModel.login(name: name, password: password)
                        }
                        
//                        if viewModel.isLoggedIn {
//                            MainTabView()
//                        }
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
                    
                    HStack {
                        Text("Don't have an account?")
                        
                        NavigationLink("SignUp") {
                            SignUpView()
                        }
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    LoginView()
}
