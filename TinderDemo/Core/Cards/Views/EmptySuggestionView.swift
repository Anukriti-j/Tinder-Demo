import SwiftUI

struct EmptySuggestionView: View {
    var body: some View {
        VStack {
            Image(systemName: "photo")
                .resizable()
                .frame(width: 200, height: 200)
                .foregroundStyle(.gray.opacity(0.5))
            Text("No more suggestions")
                .font(.subheadline)
        }
    }
}

#Preview {
    EmptySuggestionView()
}
