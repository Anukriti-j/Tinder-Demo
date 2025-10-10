import SwiftUI

struct CardStackView: View {
    @EnvironmentObject var localNotificationManager: LocalNotificationManager
    @StateObject private var cardViewModel = CardViewModel(service: CardService())
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                ZStack {
                    ForEach(cardViewModel.cardModels) { card in
                        CardView(cardViewModel: cardViewModel, model: card)
                    }
                }
                if !cardViewModel.cardModels.isEmpty {
                    SwipeActionButtons(cardViewModel: cardViewModel)
                } else {
                    EmptySuggestionView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(.soulmateLogo)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                }
            }
        }
    }
}

#Preview {
    CardStackView()
}
