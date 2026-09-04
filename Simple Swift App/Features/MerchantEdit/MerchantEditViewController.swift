////  Features/MerchantEdit/MerchantEditViewController.swift
//
//import UIKit
//import PhotosUI
//import UniformTypeIdentifiers
//
//class MerchantEditViewController: BaseFormViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
//    
//    // MARK: INJECTED DEPENDENCIES
//    var merchant: MerchantModel!
//    var repository: MerchantRepository!
//    var navigator: AppNavigator!
//    
//    // MARK: UI COMPONENTS
//    private let fieldTitleLabel = UILabel()
//    private let photoInstructionLabel = UILabel()
//    private let textField = UITextField()
//    private let errorLabel = UILabel()
//    
//    private let photoButton = UIButton(type: .system)
//    private let photoImageView = UIImageView()
//    private var currentPhotoData: Data?
//    private var customPhotoErrorMessage = ""
//    
//    private var hasInteracted = false
//    
//    // MARK: LIFECYCLE
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setupCustomFields()
//        configureForActiveField()
//        populateInitialData()
//        validateForm()
//    }
//    
//    // MARK: LAYOUT SETUP
//    private func setupCustomFields() {
//        // submit button
//        submitButton.setTitle("Simpan", for: .normal)
//        submitButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
//        
//        fieldTitleLabel.font = .systemFont(ofSize: 16, weight: .heavy)
//        fieldTitleLabel.textColor = UIColor(red: 0.09, green: 0.36, blue: 0.62, alpha: 1.0)
//        
//        photoInstructionLabel.font = .systemFont(ofSize: 12)
//        photoInstructionLabel.textColor = .secondaryLabel
//        photoInstructionLabel.numberOfLines = 2
//        
//        textField.borderStyle = .roundedRect
//        textField.delegate = self
//        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
//        textField.tintColor = UIColor(red: 0.09, green: 0.36, blue: 0.62, alpha: 1.0)
//        textField.autocorrectionType = .no
//        textField.spellCheckingType = .no
//        textField.autocapitalizationType = .none
//        
//        errorLabel.font = .systemFont(ofSize: 12)
//        errorLabel.textColor = .systemRed
//        errorLabel.numberOfLines = 2
//        errorLabel.alpha = 0
//        
//        let dummyErrorLabel = UILabel()
//        dummyErrorLabel.font = errorLabel.font
//        dummyErrorLabel.numberOfLines = 2
//        dummyErrorLabel.text = "X\nX"
//        dummyErrorLabel.isHidden = true
//        dummyErrorLabel.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(dummyErrorLabel)
//        
//        photoButton.setImage(UIImage(systemName: "camera"), for: .normal)
//        photoButton.tintColor = .label
//        photoButton.backgroundColor = .clear
//        photoButton.layer.cornerRadius = 8
//        photoButton.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
//        
//        photoImageView.contentMode = .scaleAspectFill
//        photoImageView.clipsToBounds = true
//        photoImageView.layer.cornerRadius = 8
//        photoImageView.translatesAutoresizingMaskIntoConstraints = false
//        photoButton.addSubview(photoImageView)
//        
//        // add to base stackView
//        stackView.addArrangedSubview(fieldTitleLabel)
//        stackView.addArrangedSubview(photoInstructionLabel)
//        stackView.addArrangedSubview(textField)
//        stackView.addArrangedSubview(photoButton)
//        stackView.addArrangedSubview(errorLabel)
//        
//        // custom constraints
//        NSLayoutConstraint.activate([
//            textField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
//            photoButton.heightAnchor.constraint(equalToConstant: 150),
//            errorLabel.heightAnchor.constraint(equalTo: dummyErrorLabel.heightAnchor),
//            photoInstructionLabel.heightAnchor.constraint(equalTo: dummyErrorLabel.heightAnchor),
//            
//            photoImageView.topAnchor.constraint(equalTo: photoButton.topAnchor),
//            photoImageView.leadingAnchor.constraint(equalTo: photoButton.leadingAnchor),
//            photoImageView.trailingAnchor.constraint(equalTo: photoButton.trailingAnchor),
//            photoImageView.bottomAnchor.constraint(equalTo: photoButton.bottomAnchor)
//        ])
//    }
//    
//    // MARK: LOGIC SETUP
//    private func configureForActiveField() {
//        let field = repository.activeEditField
//        let isPhoto = (field == .foto)
//        
//        textField.isHidden = isPhoto
//        photoButton.isHidden = !isPhoto
//        photoInstructionLabel.isHidden = !isPhoto
//        
//        if isPhoto {
//            stackView.setCustomSpacing(10, after: photoInstructionLabel)
//        } else {
//            stackView.setCustomSpacing(4, after: textField)
//        }
//        
//        switch field {
//        case .ktp:
//            fieldTitleLabel.text = "No KTP"; textField.keyboardType = .numberPad
//        case .npwp:
//            fieldTitleLabel.text = "NPWP"; textField.keyboardType = .numberPad
//        case .nomorRekening:
//            fieldTitleLabel.text = "Nomor Rekening"; textField.keyboardType = .numberPad
//        case .namaUsaha:
//            fieldTitleLabel.text = "Nama Usaha di Stiker QRIS"; textField.keyboardType = .default
//        case .foto:
//            fieldTitleLabel.text = "Upload Gambar"
//        case .nama:
//            fieldTitleLabel.text = "Nama"; textField.keyboardType = .default
//        case .nomorHp:
//            fieldTitleLabel.text = "No HP"; textField.keyboardType = .numberPad
//        case .nominal:
//            fieldTitleLabel.text = "Nominal"; textField.keyboardType = .numberPad
//        case .tanggal:
//            fieldTitleLabel.text = "Tanggal"; textField.keyboardType = .numberPad
//        default:
//            break
//        }
//    }
//    
//    private func populateInitialData() {
//        switch repository.activeEditField {
//        case .ktp:
//            textField.text = repository.draftKtp
//        case .npwp:
//            textField.text = repository.draftNpwp
//        case .nomorRekening:
//            textField.text = repository.draftNomorRekening
//        case .namaUsaha:
//            textField.text = repository.draftNamaUsaha
//        case .nama:
//            textField.text = repository.draftNama
//        case .nomorHp:
//            textField.text = repository.draftNomorHp
//        case .nominal:
//            textField.text = repository.draftNominal
//        case .tanggal:
//            textField.text = repository.draftTanggal
//        case .foto:
//            currentPhotoData = repository.draftPhoto
//            updatePhotoUI()
//        default:
//            break
//        }
//    }
//    
//    // MARK: REAL-TIME FORMATTING
//    @objc private func textFieldDidChange() {
//        hasInteracted = true
//        guard let input = textField.text else { return }
//        
//        let field = repository.activeEditField
//        var formatted = input
//        let rawDigits = input.filter { $0.isNumber }
//        
//        switch field {
//        case .ktp:
//            let limited = String(rawDigits.prefix(16))
//            var temp = ""
//            for (index, char) in limited.enumerated() {
//                if index != 0 && index % 4 == 0 {
//                    temp.append(" ")
//                }
//                temp.append(char)
//            }
//            formatted = temp
//        case .npwp, .nomorRekening:
//            formatted = String(rawDigits.prefix(16))
//        case .namaUsaha:
//            formatted = String(input.prefix(23))
//        case .nama:
//            formatted = String(input.filter { $0.isLetter || $0.isNumber || $0.isWhitespace }.prefix(100))
//        case .nomorHp:
//            formatted = String(rawDigits.prefix(13))
//        case .nominal:
//            let digits = String(rawDigits.prefix(16))
//            if let number = Int64(digits) {
//                formatted = MerchantModel.sharedNumberFormatter.string(from: NSNumber(value: number)) ?? digits
//            } else {
//                formatted = ""
//            }
//        case .tanggal:
//            let digits = String(rawDigits.prefix(8))
//            var temp = ""
//            for (index, char) in digits.enumerated() {
//                if index == 4 || index == 6 {
//                    temp.append("-")
//                }
//                temp.append(char)
//            }
//            formatted = temp
//        default:
//            break
//        }
//        
//        if textField.text != formatted {
//            textField.text = formatted
//        }
//        validateForm()
//    }
//    
//    // MARK: VALIDATION
//    private func validateForm() {
//        let field = repository.activeEditField
//        let text = textField.text ?? ""
//        var isValid = false
//        var errorMsg = ""
//        
//        switch field {
//        case .ktp:
//            isValid = MerchantModel.isKtpValid(text)
//            if !isValid && hasInteracted {
//                errorMsg = "KTP wajib diisi (harus 16 digit angka)."
//            }
//        case .npwp:
//            isValid = MerchantModel.isNpwpValid(text)
//            if !isValid && hasInteracted {
//                errorMsg = "NPWP wajib diisi (maks 16 digit angka)."
//            }
//        case .nomorRekening:
//            isValid = MerchantModel.isNomorRekeningValid(text)
//            if !isValid && hasInteracted {
//                errorMsg = "Nomor Rekening wajib diisi (maks 16 digit angka)."
//            }
//        case .namaUsaha:
//            isValid = MerchantModel.isNamaUsahaValid(text)
//            if !isValid && hasInteracted {
//                errorMsg = "Maks 23 karakter, tanpa spasi di awal/akhir."
//            }
//        case .nama:
//            isValid = MerchantModel.isNamaValid(text)
//            if !isValid && hasInteracted {
//                errorMsg = "Nama wajib diisi (maks 100 karakter), tanpa spasi."
//            }
//        case .nomorHp:
//            isValid = MerchantModel.isNomorHpValid(text)
//            if !isValid && hasInteracted {
//                errorMsg = "Nomor HP harus antara 10-13 digit angka."
//            }
//        case .nominal:
//            isValid = MerchantModel.isNominalValid(text)
//            if !isValid && hasInteracted {
//                errorMsg = "Nominal wajib diisi (maks 16 digit angka)."
//            }
//        case .tanggal:
//            if text.isEmpty { isValid = true }
//            else { isValid = (text.count == 10 && MerchantModel.sharedDateFormatter.date(from: text) != nil) }
//            if !isValid && hasInteracted {
//                errorMsg = "Format tanggal harus yyyy-MM-dd dan valid."
//            }
//        case .foto:
//            isValid = MerchantModel.isFotoValid(currentPhotoData)
//            if !customPhotoErrorMessage.isEmpty {
//                isValid = false
//                photoInstructionLabel.text = customPhotoErrorMessage
//                photoInstructionLabel.textColor = .systemRed
//            } else {
//                photoInstructionLabel.text = "Maksimal 5MB. Format: PNG, JPG, JPEG, HEIF."
//                photoInstructionLabel.textColor = .secondaryLabel
//            }
//        default:
//            break
//        }
//        
//        if field != .foto {
//            errorLabel.text = errorMsg
//            errorLabel.alpha = errorMsg.isEmpty ? 0 : 1.0
//        } else {
//            errorLabel.alpha = 0
//        }
//        
//        submitButton.isEnabled = isValid
//        submitButton.alpha = isValid ? 1.0 : 0.5
//    }
//    
//    // MARK: ACTIONS
//    @objc private func saveTapped() {
//        let field = repository.activeEditField
//        let text = textField.text ?? ""
//        
//        if field == .foto {
//            repository.draftPhoto = currentPhotoData
//        } else {
//            switch field {
//            case .ktp:
//                repository.draftKtp = text
//            case .npwp:
//                repository.draftNpwp = text
//            case .nomorRekening:
//                repository.draftNomorRekening = text
//            case .namaUsaha:
//                repository.draftNamaUsaha = text
//            case .nama:
//                repository.draftNama = text
//            case .nomorHp:
//                repository.draftNomorHp = text
//            case .nominal:
//                repository.draftNominal = text
//            case .tanggal:
//                repository.draftTanggal = text
//            default:
//                break
//            }
//        }
//        
//        let rawNominal = repository.draftNominal.filter { $0.isNumber }
//        let rawKtp = repository.draftKtp.filter { $0.isNumber }
//        
//        let updatedMerchant = MerchantModel(
//            ktp: rawKtp, npwp: repository.draftNpwp, nomorRekening: repository.draftNomorRekening,
//            namaUsaha: repository.draftNamaUsaha, foto: repository.draftPhoto, nama: repository.draftNama,
//            nomorHp: repository.draftNomorHp, nominal: rawNominal,
//            tanggal: MerchantModel.sharedDateFormatter.date(from: repository.draftTanggal)
//        )
//        
//        repository.activeEditField = .none
//        navigator.path = [.result(merchant: updatedMerchant)]
//    }
//    
//    // MARK: PHOTO LOGIC
//    @objc private func photoButtonTapped() {
//        let sheetVC = PhotoSourceSheetViewController()
//        sheetVC.onSelectCamera = { [weak self] in self?.openCamera() }
//        sheetVC.onSelectGallery = { [weak self] in self?.openGallery() }
//        
//        if let sheet = sheetVC.sheetPresentationController {
//            sheet.detents = [.custom { _ in 250 }, .medium()]
//            sheet.prefersGrabberVisible = true
//        }
//        present(sheetVC, animated: true)
//    }
//    
//    private func openCamera() {
//        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.sourceType = .camera
//        present(picker, animated: true)
//    }
//    
//    private func openGallery() {
//        var config = PHPickerConfiguration(photoLibrary: .shared())
//        config.filter = .images
//        config.selectionLimit = 1
//        let picker = PHPickerViewController(configuration: config)
//        picker.delegate = self
//        present(picker, animated: true)
//    }
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true)
//        hasInteracted = true
//        if let image = info[.originalImage] as? UIImage {
//            if let data = image.jpegData(compressionQuality: 1.0) {
//                processRawPhotoData(data)
//            }
//        }
//    }
//    
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        picker.dismiss(animated: true)
//        hasInteracted = true
//        guard let provider = results.first?.itemProvider else { return }
//        
//        let allowedTypes: [UTType] = [.jpeg, .png, .heic, .heif]
//        guard let typeIdentifier = provider.registeredTypeIdentifiers.first,
//              let utType = UTType(typeIdentifier),
//              allowedTypes.contains(utType) else {
//            DispatchQueue.main.async {
//                self.currentPhotoData = nil
//                self.customPhotoErrorMessage = "Format tidak didukung. Gunakan PNG, JPG, JPEG, atau HEIF."
//                self.updatePhotoUI()
//                self.validateForm()
//            }
//            return
//        }
//        
//        provider.loadDataRepresentation(forTypeIdentifier: typeIdentifier) { data, _ in
//            DispatchQueue.main.async {
//                if let data = data {
//                    self.processRawPhotoData(data)
//                } else {
//                    self.currentPhotoData = nil
//                    self.customPhotoErrorMessage = "Gagal upload foto."
//                    self.updatePhotoUI()
//                    self.validateForm()
//                }
//            }
//        }
//    }
//    
//    private func processRawPhotoData(_ data: Data) {
//        if data.count > 5 * 1024 * 1024 {
//            currentPhotoData = nil
//            customPhotoErrorMessage = "Ukuran file maks 5MB."
//        } else {
//            currentPhotoData = data
//            customPhotoErrorMessage = ""
//        }
//        updatePhotoUI()
//        validateForm()
//    }
//    
//    private func updatePhotoUI() {
//        if let data = currentPhotoData, let image = UIImage(data: data) {
//            photoImageView.image = image
//            photoImageView.isHidden = false
//            photoButton.setImage(nil, for: .normal)
//        } else {
//            photoImageView.isHidden = true
//            photoButton.setImage(UIImage(systemName: "camera"), for: .normal)
//        }
//    }
//}
