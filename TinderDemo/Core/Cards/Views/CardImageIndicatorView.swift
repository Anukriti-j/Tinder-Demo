import SwiftUI
import SwiftData

struct CardImageIndicatorView: View {
    @Query var storedImages: [ProfileImageModel]
    let currentImageIndex: Int
    
    var body: some View {
        HStack {
            ForEach( 0 ..< imageCount, id: \.self) { index in
                Capsule()
                    .foregroundStyle(currentImageIndex == index ? .white: .gray)
                    .frame(width: imageIndicatorWidth, height: 4)
                    .padding(.top, 8)
            }
        }
    }
}

private extension CardImageIndicatorView {
    var imageIndicatorWidth: CGFloat {
        return SizeConstants.cardWidth / CGFloat(imageCount) - 28
    }
    
    var imageCount: Int {
        return storedImages.count
    }
}

#Preview {
    CardImageIndicatorView(currentImageIndex: 1)
        .preferredColorScheme(.dark)
}
