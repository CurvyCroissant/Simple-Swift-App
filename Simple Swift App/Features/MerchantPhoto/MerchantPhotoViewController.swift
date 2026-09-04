//  Features/MerchantPhoto/MerchantPhotoViewController.swift

import UIKit
import PhotosUI
import UniformTypeIdentifiers

class MerchantPhotoViewController: BaseFormViewController {
    var merchant: MerchantModel?
    
    // MARK: UI COMPONENTS
    private let uploadTitleLabel = UILabel()
    private let infoLabel = UILabel()
    private let imageContainerButton = UIButton(type: .system)
    
    private let maxFileSize = 5 * 1024 * 1024
    
    // MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Registrasi 2/3"
        
        setupPhotoLayout()
        validateForm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // restore cached image
        if let cachedData = MerchantRepository.shared.draftPhoto {
            processRawData(cachedData)
        }
    }
    
    // MARK: LAYOUT
    private func setupPhotoLayout() {
        // title
        uploadTitleLabel.text = "Upload Gambar"
        uploadTitleLabel.font = .systemFont(ofSize: 17, weight: .heavy)
        uploadTitleLabel.textColor = UIColor(red: 0.09, green: 0.36, blue: 0.62, alpha: 1.0)
        
        // info + error label
        infoLabel.text = "Maksimal 5MB. Format: PNG, JPG, JPEG, HEIF."
        infoLabel.font = .systemFont(ofSize: 12)
        infoLabel.textColor = .systemGray
        infoLabel.numberOfLines = 0
        
        // image container button
        imageContainerButton.heightAnchor.constraint(equalToConstant: 150).isActive = true
        imageContainerButton.layer.cornerRadius = 8
        imageContainerButton.clipsToBounds = true
        imageContainerButton.backgroundColor = .clear
        imageContainerButton.tintColor = .black
        imageContainerButton.addTarget(self, action: #selector(showSourceSelector), for: .touchUpInside)
        
        setEmptyImageState()
        
        stackView.addArrangedSubview(uploadTitleLabel)
        stackView.addArrangedSubview(infoLabel)
        stackView.addArrangedSubview(imageContainerButton)
        
        submitButton.setTitle("Lanjut", for: .normal)
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
    }
    
    // MARK: STATE MANAGEMENT
    private func setEmptyImageState() {
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
        let cameraIcon = UIImage(systemName: "camera", withConfiguration: config)
        imageContainerButton.setImage(cameraIcon, for: .normal)
        imageContainerButton.imageView?.contentMode = .center
    }
    
    private func setFilledImageState(image: UIImage) {
        imageContainerButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        imageContainerButton.contentHorizontalAlignment = .fill
        imageContainerButton.contentVerticalAlignment = .fill
        imageContainerButton.imageView?.contentMode = .scaleAspectFill
    }
    
    private func processRawData(_ data: Data) {
        if data.count > maxFileSize {
            infoLabel.text = "Ukuran file maks 5MB."
            infoLabel.textColor = .systemRed
            MerchantRepository.shared.draftPhoto = nil
            setEmptyImageState()
        } else {
            infoLabel.text = "Maksimal 5MB. Format: PNG, JPG, JPEG, HEIF."
            infoLabel.textColor = .systemGray
            MerchantRepository.shared.draftPhoto = data
            if let image = UIImage(data: data) {
                setFilledImageState(image: image)
            }
        }
        validateForm()
    }
    
    private func validateForm() {
        let isValid = MerchantRepository.shared.draftPhoto != nil && infoLabel.textColor == .systemGray
        submitButton.isEnabled = isValid
        submitButton.alpha = isValid ? 1.0 : 0.5
    }
    
    // MARK: ACTIONS
    @objc private func showSourceSelector() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Kamera", style: .default) { [weak self] _ in
            self?.openCamera()
        })
        
        sheet.addAction(UIAlertAction(title: "Galeri", style: .default) { [weak self] _ in
            self?.openGallery()
        })
        
        sheet.addAction(UIAlertAction(title: "Batal", style: .cancel))
        present(sheet, animated: true)
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
        
        // Pass to step 3
        // let detailsVC = MerchantDetailsViewController()
        // detailsVC.merchant = nextMerchant
        // navigationController?.pushViewController(detailsVC, animated: true)
    }
}

// MARK: GALLERY
extension MerchantPhotoViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let itemProvider = results.first?.itemProvider else {
            return
        }
        
        // Matches SwiftUI allowedTypes validation logic
        let allowedTypes = [UTType.jpeg.identifier, UTType.png.identifier, UTType.heic.identifier, UTType.heif.identifier]
        let hasValidType = itemProvider.registeredTypeIdentifiers.contains { allowedTypes.contains($0) }
        
        guard hasValidType else {
            DispatchQueue.main.async {
                self.infoLabel.text = "Format tidak didukung. Gunakan PNG, JPG, JPEG, atau HEIF."
                self.infoLabel.textColor = .systemRed
                MerchantRepository.shared.draftPhoto = nil
                self.setEmptyImageState()
                self.validateForm()
            }
            return
        }
        
        itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { [weak self] data, error in
            DispatchQueue.main.async {
                if let validData = data {
                    self?.processRawData(validData)
                } else {
                    self?.infoLabel.text = "Gagal upload foto atau format tidak didukung."
                    self?.infoLabel.textColor = .systemRed
                    self?.setEmptyImageState()
                    self?.validateForm()
                }
            }
        }
    }
}

// MARK: CAMERA
extension MerchantPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage, let data = image.jpegData(compressionQuality: 0.8) {
            processRawData(data)
        }
    }
}
