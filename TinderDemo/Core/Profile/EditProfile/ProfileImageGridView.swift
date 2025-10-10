import SwiftUI
import PhotosUI

struct ProfileImageGridView: View {
    let user: User
    @State private var showImagepIcker = false
    @State private var showSourceActionSheet = false
    @State private var selectedImage: UIImage?
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(0 ..< 6) { index in
                if index < user.profileImageURLs.count {
                    Image(user.profileImageURLs[index])
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageWidth, height: imageHeight)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                } else {
                    ZStack(alignment: .bottomTrailing) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.secondarySystemBackground))
                            .frame(width: imageWidth, height: imageHeight)
                        
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                            .foregroundStyle(Color.pink)
                            .offset(x: 4,y: 4)
                    }
                }
            }
        }
        .confirmationDialog("Select Image Source", isPresented: $showSourceActionSheet) {
            Button("Camera") {
                sourceType = .camera
                showImagepIcker = true
            }
            Button("Photo Library") {
                sourceType = .photoLibrary
                showImagepIcker = true
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showImagepIcker) {
            ImagePicker(sourceType: $sourceType, selectedImage: $selectedImage)
        }
//        .onChange(of: selectedImage) { _, newValue in
//            if let newImage = newImage {
//
//        }
//        
    }
}


private extension ProfileImageGridView {
    var columns: [GridItem] {
        [
            .init(.flexible()),
            .init(.flexible()),
            .init(.flexible())
        ]
    }
    
    var imageWidth: CGFloat {
        return 110
    }
    
    var imageHeight: CGFloat {
        return 160
    }
}

//#Preview {
//    ProfileImageGridView(user: MockData.users[1])
//}
