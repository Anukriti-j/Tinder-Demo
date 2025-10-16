import SwiftUI
import Foundation
import NotificationCenter
import SwiftData

@MainActor
struct CardView: View {
    @Query var storedImages: [ProfileImageModel]
    @EnvironmentObject var localNotificationManager: LocalNotificationManager
    @ObservedObject var cardViewModel: CardViewModel
    
    @State private var xOffset: CGFloat = 0
    @State private var degrees: Double = 0
    @State private var currentImageIndex = 0
    @State private var showProfileSheet: Bool = false
    let model: CardModel
   
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top) {
                Image(uiImage: storedImages[currentImageIndex].uiImage!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: SizeConstants.cardWidth, height: SizeConstants.cardHeight)
                    .clipped()
                    .overlay {
                        ImageScrollingOverlay(currentImageIndex: $currentImageIndex, imageCount: imageCount)
                    }
                CardImageIndicatorView(currentImageIndex: currentImageIndex)
                SwipeActionIndicatorView(xOffset: $xOffset)
            }
            UserInfoView(showProfileSheet: $showProfileSheet, user: user)
        }
        .fullScreenCover(isPresented: $showProfileSheet) {
            UserProfileView(user: user)
        }
        .onReceive(cardViewModel.$swipeButtonAction, perform: { action in
            onReceiveSwipeAction(action)
        })
        .frame(width: SizeConstants.cardWidth, height: SizeConstants.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .offset(x: xOffset)
        .rotationEffect(.degrees(degrees))
        .animation(.snappy, value: xOffset)
        .gesture(
            DragGesture()
                .onChanged(onDragChanged)
                .onEnded(onDragEnded)
        )
        
    }
}

private extension CardView {
    var user: User {
        return model.user
    }
    
    var imageCount: Int {
        return storedImages.count
    }
}

@MainActor
private extension CardView {
    func returnToCentre() {
        xOffset = 0
        degrees = 0
    }
    
    func swipeRight() {
        print("Swipe right called")
        withAnimation {
            xOffset = 500
            degrees = 12
        } completion: {
            cardViewModel.removeCard(model)
            localNotificationManager.scheduleBatchNotification(user: user)
        }
    }
    
    func swipeLeft() {
        print("swipe left called")
        withAnimation {
            xOffset = -500
            degrees = -12
        } completion: {
            cardViewModel.removeCard(model)
        }
    }
    
    func onReceiveSwipeAction(_ action: SwipeAction?) {
        guard let action else { return }
        
        let topCard = cardViewModel.cardModels.last // to make sure we are only performing swipe action on last stack card and not all
        if topCard == model {
            switch action {
            case .reject:
                swipeLeft()
            case .like:
                swipeRight()
            }
        }
    }
}

private extension CardView {
    func onDragChanged(_ value: _ChangedGesture<DragGesture>.Value) {
        xOffset = value.translation.width
        degrees = Double(value.translation.width / 25 )
    }
    
    func onDragEnded(_ value: _ChangedGesture<DragGesture>.Value) {
        let width = value.translation.width
        if abs(width) <= abs(SizeConstants.screenCutoff) {
            returnToCentre()
            return
        }
        
        if width >= SizeConstants.screenCutoff {
            swipeRight()
            
        } else {
            swipeLeft()
        }
    }
}

#Preview {
    CardView(
        cardViewModel: CardViewModel(
            service: CardService()
        ),
        model: CardModel(
            user: MockData.users[1]
        )
    )
}
