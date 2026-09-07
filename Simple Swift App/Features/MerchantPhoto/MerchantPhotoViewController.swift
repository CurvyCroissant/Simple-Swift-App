//  Features/MerchantPhoto/MerchantPhotoViewController.swift

import UIKit
import PhotosUI
import UniformTypeIdentifiers

class MerchantPhotoViewController: BaseFormViewController {
    var merchant: MerchantModel?
    
    private var photoView: MerchantPhotoView { formView as! MerchantPhotoView }
    private var imageField: ImageUploadField { photoView.imageField }
    
    private let maxFileSize = 5 * 1024 * 1024
    
    override func makeFormView() -> BaseFormView {
        MerchantPhotoView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Registrasi 2/3"
        
        imageField.onTap = { [weak self] in self?.showSourceSelector() }
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        validateForm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let cachedData = MerchantRepository.shared.draftPhoto {
            processRawData(cachedData)
        }
    }
    
    private func processRawData(_ data: Data) {
        if data.count > maxFileSize {
            imageField.setInfo("Ukuran file maks 5MB.", isError: true)
            MerchantRepository.shared.draftPhoto = nil
            imageField.setEmptyState()
        } else {
            imageField.setInfo("Maksimal 5MB. Format: PNG, JPG, JPEG, HEIF.", isError: false)
            MerchantRepository.shared.draftPhoto = data
            if let image = UIImage(data: data) {
                imageField.setFilledState(image: image)
            }
        }
        validateForm()
    }
    
    private func validateForm() {
        let isValid = MerchantRepository.shared.draftPhoto != nil && !imageField.hasError
        submitButton.isEnabled = isValid
        submitButton.alpha = isValid ? 1 : 0.5
    }
    
    private func showSourceSelector() {
        let sheetVC = PhotoSourceSheetViewController()
        sheetVC.onCameraSelected = { [weak self] in self?.openCamera() }
        sheetVC.onGallerySelected = { [weak self] in self?.openGallery() }
        present(sheetVC, animated: true)
    }
    
    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func openGallery() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func submitTapped() {
        guard let validMerchant = merchant else {
            return
        }
        var nextMerchant = validMerchant
        nextMerchant.foto = MerchantRepository.shared.draftPhoto
        Navigator.shared.showMerchantDetails(for: nextMerchant)
    }
}

extension MerchantPhotoViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let itemProvider = results.first?.itemProvider else {
            return
        }
        
        let allowedTypes = [UTType.jpeg.identifier, UTType.png.identifier, UTType.heic.identifier, UTType.heif.identifier]
        let hasValidType = itemProvider.registeredTypeIdentifiers.contains { allowedTypes.contains($0) }
        
        guard hasValidType else {
            DispatchQueue.main.async {
                self.imageField.setInfo("Format tidak didukung. Gunakan PNG, JPG, JPEG, atau HEIF.", isError: true)
                MerchantRepository.shared.draftPhoto = nil
                self.imageField.setEmptyState()
                self.validateForm()
            }
            return
        }
        
        itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { [weak self] data, error in
            DispatchQueue.main.async {
                if let validData = data {
                    self?.processRawData(validData)
                } else {
                    self?.imageField.setInfo("Gagal upload foto atau format tidak didukung.", isError: true)
                    self?.imageField.setEmptyState()
                    self?.validateForm()
                }
            }
        }
    }
}

extension MerchantPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage, let data = image.jpegData(compressionQuality: 1) {
            processRawData(data)
        }
    }
}
