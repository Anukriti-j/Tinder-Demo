import SwiftUI
import SwiftData

@Model
class ProfileImageModel {
    var id: UUID
    var imageData: Data
    
    init(image: UIImage) {
        self.id = UUID()
        self.imageData = image.jpegData(compressionQuality: 0.8) ?? Data()
    }
    
    var uiImage: UIImage? {
        UIImage(data: imageData)
    }
}
