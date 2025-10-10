import SwiftUI

struct CurrentUserProfileHeaderView: View {
    let user: APIUser?
    
    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                Image("Anukriti-2")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .background {
                        Circle()
                            .fill(.white)
                            .frame(width: 128, height: 128)
                            .shadow(radius: 10)
                    }
                
                Image(systemName: "pencil")
                    .imageScale(.small)
                    .foregroundStyle(.gray)
                    .background {
                        Circle()
                            .fill(.white)
                            .frame(width: 32, height: 32)
                    }
                    .offset(x: -8, y: 10)
            }
        
            Text("\(user?.username ?? "Unknown"), 22")
                .font(.title2)
                .fontWeight(.light)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 240)
    }
}

//#Preview {
//    CurrentUserProfileHeaderView(user: MockData.users[1])
//}
