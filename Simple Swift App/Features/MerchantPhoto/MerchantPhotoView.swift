//  Features/MerchantPhoto/MerchantPhotoView.swift

import UIKit

class MerchantPhotoView: BaseFormView {
    let imageField = ImageUploadField(
        title: "Upload Gambar",
        infoText: "Maksimal 5MB. Format: PNG, JPG, JPEG, HEIF."
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        formCard.addField(imageField)
        submitButton.setTitle("Lanjut", for: .normal)
        
        submitButton.setTitle("Lanjut", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
