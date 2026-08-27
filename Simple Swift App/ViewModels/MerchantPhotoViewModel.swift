//  ViewModels/MerchantPhotoViewModel.swift

import SwiftUI
import Combine
import PhotosUI
import UniformTypeIdentifiers

class MerchantPhotoViewModel: ObservableObject {
    @Published var selectedItem: PhotosPickerItem? = nil {
        didSet {
            processGalleryImage(selectedItem)
        }
    }
    @Published var selectedImageData: Data? = nil
    @Published var errorMessage: String = ""
    
    // Max 5MB
    let maxFileSize = 5 * 1024 * 1024
    
    var canSubmit: Bool {
        selectedImageData != nil && errorMessage.isEmpty
    }
    
    func processRawData(_ data: Data) {
        if data.count > self.maxFileSize {
            self.errorMessage = "Ukuran file maksimal 5MB."
            self.selectedImageData = nil
        } else {
            self.errorMessage = ""
            self.selectedImageData = data
        }
    }
    
    private func processGalleryImage(_ item: PhotosPickerItem?) {
        guard let item = item else {
            return
        }
        
        // Checks true, original format. Rejects raw
        let allowedTypes: [UTType] = [.jpeg, .png, .heic, .heif]
        
        guard let primaryType = item.supportedContentTypes.first, allowedTypes.contains(primaryType) else {
            DispatchQueue.main.async {
                self.errorMessage = "Format tidak didukung. Gunakan PNG, JPG, JPEG, atau HEIF."
                self.selectedImageData = nil
            }
            return
        }
        
        // Load data
        item.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data?):
                    self.processRawData(data)
                case .success(nil), .failure(_):
                    self.errorMessage = "Gagal upload foto atau format tidak didukung."
                    self.selectedImageData = nil
                }
            }
        }
    }
}
