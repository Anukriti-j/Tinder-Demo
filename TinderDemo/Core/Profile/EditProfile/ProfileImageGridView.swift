import SwiftUI
import PhotosUI
import SwiftData

struct ProfileImageGridView: View {
    @Environment(\.modelContext) var context
    @Query var storedImages: [ProfileImageModel]
    @State private var showImagepIcker = false
    @State private var showSourceActionSheet = false
    @State private var selectedImages: [UIImage?] = Array(repeating: nil, count: 6)
    @State private var selectedImage: UIImage?
    @State private var selectedIndex: Int? = nil
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    let user: User
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(0..<6, id: \.self) { index in
                ZStack(alignment: .bottomTrailing) {
                    imagegridCell(for: index)
                }
            }
        }
        .confirmationDialog("Select Image Source", isPresented: $showSourceActionSheet) {
            Button("Camera") {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    sourceType = .camera
                } else {
                    sourceType = .photoLibrary
                }
                showImagepIcker = true
            }
            Button("Photo Library") {
                sourceType = .photoLibrary
                showImagepIcker = true
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showImagepIcker) {
            ImagePicker(sourceType: sourceType) { image in
                handleSelectedImage(image)
            }
        }
    }
}

private extension ProfileImageGridView {
    @ViewBuilder
    func imagegridCell(for index: Int) -> some View {
        if index < storedImages.count,
           let uiImage = storedImages[index].uiImage {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: imageWidth, height: imageHeight)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
        } else {
            
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.secondarySystemBackground))
                .frame(width: imageWidth, height: imageHeight)
                .overlay(addButton(for: index))
        }
    }
    
    func addButton(for index: Int) -> some View {
        Button {
            selectedIndex = index
            showSourceActionSheet = true
        } label: {
            Image(systemName: "plus.circle.fill")
                .imageScale(.large)
                .foregroundStyle(.pink)
                .offset(y: -2)
        }
    }
}

private extension ProfileImageGridView {
    func handleSelectedImage(_ image: UIImage) {
        let newModel = ProfileImageModel(image: image)
        context.insert(newModel)
        try? context.save()
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
//    ProfileImageGridView(context: ModelContext)
//        .environmentObject(LocalNotificationManager())
//}
