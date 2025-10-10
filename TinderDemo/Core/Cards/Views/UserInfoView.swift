import SwiftUI

struct UserInfoView: View {
    @Binding var showProfileSheet: Bool
    let user: User
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(user.fullName)
                    .font(.headline)
                    .fontWeight(.heavy)
                Text("\(user.age)")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button {
                    showProfileSheet.toggle()
                } label: {
                    Image(systemName: "arrow.up.circle")
                        .fontWeight(.bold)
                        .imageScale(.large)
                }
            }
            Text("some test bio ...")
                .font(.subheadline)
                .lineLimit(2)
        }
        .padding()
        .foregroundStyle(.white)
        .padding(.horizontal)
        .background(
            LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom)
        )
    }
}

#Preview {
    UserInfoView(showProfileSheet: .constant(true), user: MockData.users[1])
}
