// Features/MerchantEdit/MerchantEditViewController.swift

import UIKit
import PhotosUI
import UniformTypeIdentifiers

class MerchantEditViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    
    // MARK: INJECTED DEPENDENCIES
    var merchant: MerchantModel!
    var repository: MerchantRepository!
    var navigator: AppNavigator!
    
    // MARK: UI COMPONENTS
    private let headerView = UIView()
    private let titleLabel = UILabel()
    private let containerView = UIView()
    
    private let fieldTitleLabel = UILabel()
    private let textField = UITextField()
    private let errorLabel = UILabel()
    
    private let stackView = UIStackView()
    
    private let photoButton = UIButton(type: .system)
    private let photoImageView = UIImageView()
    private var currentPhotoData: Data?
    private var customPhotoErrorMessage = ""
    
    private let saveButton = UIButton(type: .system)
    
    private var hasInteracted = false
    
    // MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        
        setupLayout()
        configureForActiveField()
        populateInitialData()
        validateForm()
    }
    
    // MARK: LAYOUT SETUP
    private func setupLayout() {
        // Blue Background
        let blueBackground = UIView()
        blueBackground.backgroundColor = UIColor(red: 0.09, green: 0.36, blue: 0.62, alpha: 1.0)
        blueBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blueBackground)
        
        // Save Button
        saveButton.setTitle("Simpan", for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        saveButton.backgroundColor = UIColor(red: 0.09, green: 0.36, blue: 0.62, alpha: 1.0)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        view.addSubview(saveButton)
        
        // Scrollable View
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        let scrollContentView = UIView()
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(scrollContentView)
        
        // Liquid Glass Card (input's container)
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let glassCard = UIVisualEffectView(effect: blurEffect)
        glassCard.layer.cornerRadius = 15
        glassCard.clipsToBounds = true
        glassCard.layer.borderWidth = 1
        glassCard.layer.borderColor = UIColor.white.withAlphaComponent(0.6).cgColor
        glassCard.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.addSubview(glassCard)
        
        // UIKit VStack (dynamically shrinks when items are hidden)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        glassCard.contentView.addSubview(stackView)
        
        // Configure Elements
        fieldTitleLabel.font = .systemFont(ofSize: 16, weight: .heavy)
        fieldTitleLabel.textColor = UIColor(red: 0.09, green: 0.36, blue: 0.62, alpha: 1.0)
        
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.tintColor = UIColor(red: 0.09, green: 0.36, blue: 0.62, alpha: 1.0)
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.autocapitalizationType = .none
        
        errorLabel.font = .systemFont(ofSize: 12)
        errorLabel.textColor = .systemRed
        errorLabel.numberOfLines = 2
        errorLabel.text = " "
        errorLabel.alpha = 0
        
        let dummyErrorLabel = UILabel()
        dummyErrorLabel.font = errorLabel.font
        dummyErrorLabel.numberOfLines = 2
        dummyErrorLabel.text = "X\nX"
        dummyErrorLabel.isHidden = true
        dummyErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dummyErrorLabel)
        
        photoButton.setImage(UIImage(systemName: "camera"), for: .normal)
        photoButton.tintColor = .label
        photoButton.backgroundColor = .clear
        photoButton.layer.cornerRadius = 8
        photoButton.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
        
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 8
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoButton.addSubview(photoImageView)
        
        // Add to StackView
        stackView.addArrangedSubview(fieldTitleLabel)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(photoButton)
        stackView.addArrangedSubview(errorLabel)
        stackView.setCustomSpacing(4, after: textField)
        
        // MARK: CONSTRAINTS
        NSLayoutConstraint.activate([
            // Background
            blueBackground.topAnchor.constraint(equalTo: view.topAnchor),
            blueBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blueBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blueBackground.heightAnchor.constraint(equalToConstant: 350),
            
            // Save Button
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -10),
            
            scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Glass Card
            glassCard.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: 20),
            glassCard.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 20),
            glassCard.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -20),
            glassCard.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -20),
            
            // StackView
            stackView.topAnchor.constraint(equalTo: glassCard.contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: glassCard.contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: glassCard.contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: glassCard.contentView.bottomAnchor, constant: -16),
            
            // Responsive Heights for inputs
            textField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            photoButton.heightAnchor.constraint(equalToConstant: 150), // Matches SwiftUI .frame(height: 150)
            
            // Dynamically locks the height to exactly 2 lines based on current system font size
            errorLabel.heightAnchor.constraint(equalTo: dummyErrorLabel.heightAnchor),
            
            photoImageView.topAnchor.constraint(equalTo: photoButton.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: photoButton.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: photoButton.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: photoButton.bottomAnchor)
        ])
    }
    
    // MARK: LOGIC SETUP
    private func configureForActiveField() {
        let field = repository.activeEditField
        
        // Visibility between TextField and PhotoPicker
        let isPhoto = (field == .foto)
        textField.isHidden = isPhoto
        photoButton.isHidden = !isPhoto
        
        // Dynamically reorder label natively (based on active field)
        stackView.removeArrangedSubview(errorLabel)
        errorLabel.removeFromSuperview()
        
        if isPhoto {
            stackView.insertArrangedSubview(errorLabel, at: 1)
            stackView.setCustomSpacing(10, after: errorLabel)
        } else {
            stackView.addArrangedSubview(errorLabel)
            stackView.setCustomSpacing(4, after: textField)
        }
        
        switch field {
        case .ktp: fieldTitleLabel.text = "No KTP"; textField.keyboardType = .numberPad
        case .npwp: fieldTitleLabel.text = "NPWP"; textField.keyboardType = .numberPad
        case .nomorRekening: fieldTitleLabel.text = "Nomor Rekening"; textField.keyboardType = .numberPad
        case .namaUsaha: fieldTitleLabel.text = "Nama Usaha di Stiker QRIS"; textField.keyboardType = .default
        case .foto: fieldTitleLabel.text = "Upload Gambar"
        case .nama: fieldTitleLabel.text = "Nama"; textField.keyboardType = .default
        case .nomorHp: fieldTitleLabel.text = "No HP"; textField.keyboardType = .numberPad
        case .nominal: fieldTitleLabel.text = "Nominal"; textField.keyboardType = .numberPad
        case .tanggal: fieldTitleLabel.text = "Tanggal"; textField.keyboardType = .numberPad
        default: break
        }
    }
    
    private func populateInitialData() {
        switch repository.activeEditField {
        case .ktp: textField.text = repository.draftKtp
        case .npwp: textField.text = repository.draftNpwp
        case .nomorRekening: textField.text = repository.draftNomorRekening
        case .namaUsaha: textField.text = repository.draftNamaUsaha
        case .nama: textField.text = repository.draftNama
        case .nomorHp: textField.text = repository.draftNomorHp
        case .nominal: textField.text = repository.draftNominal
        case .tanggal: textField.text = repository.draftTanggal
        case .foto:
            currentPhotoData = repository.draftPhoto
            updatePhotoUI()
        default: break
        }
    }
    
    // MARK: REAL-TIME FORMATTING (like .onChange)
    @objc private func textFieldDidChange() {
        hasInteracted = true
        guard let input = textField.text else {
            return
        }
        
        let field = repository.activeEditField
        var formatted = input
        
        let rawDigits = input.filter { $0.isNumber }
        
        switch field {
        case .ktp:
            let limited = String(rawDigits.prefix(16))
            var temp = ""
            for (index, char) in limited.enumerated() {
                if index != 0 && index % 4 == 0 {
                    temp.append(" ")
                }
                temp.append(char)
            }
            formatted = temp
        case .npwp, .nomorRekening:
            formatted = String(rawDigits.prefix(16))
        case .namaUsaha:
            formatted = String(input.prefix(23))
        case .nama:
            formatted = String(input.filter { $0.isLetter || $0.isNumber || $0.isWhitespace }.prefix(100))
        case .nomorHp:
            formatted = String(rawDigits.prefix(13))
        case .nominal:
            let digits = String(rawDigits.prefix(16))
            if let number = Int64(digits) {
                formatted = MerchantModel.sharedNumberFormatter.string(from: NSNumber(value: number)) ?? digits
            } else {
                formatted = ""
            }
        case .tanggal:
            let digits = String(rawDigits.prefix(8))
            var temp = ""
            for (index, char) in digits.enumerated() {
                if index == 4 || index == 6 {
                    temp.append("-")
                }
                temp.append(char)
            }
            formatted = temp
        default: break
        }
        
        // Only update if different to prevent cursor jumping
        if textField.text != formatted {
            textField.text = formatted
        }
        
        validateForm()
    }
    
    // MARK: VALIDATION
    private func validateForm() {
        let field = repository.activeEditField
        let text = textField.text ?? ""
        var isValid = false
        var errorMsg = ""
        
        switch field {
        case .ktp:
            isValid = MerchantModel.isKtpValid(text)
            if !isValid && hasInteracted { errorMsg = "KTP wajib diisi (harus 16 digit angka)." }
        case .npwp:
            isValid = MerchantModel.isNpwpValid(text)
            if !isValid && hasInteracted { errorMsg = "NPWP wajib diisi (maks 16 digit angka)." }
        case .nomorRekening:
            isValid = MerchantModel.isNomorRekeningValid(text)
            if !isValid && hasInteracted { errorMsg = "Nomor Rekening wajib diisi (maks 16 digit angka)." }
        case .namaUsaha:
            isValid = MerchantModel.isNamaUsahaValid(text)
            if !isValid && hasInteracted { errorMsg = "Maks 23 karakter, tanpa spasi di awal/akhir." }
        case .nama:
            isValid = MerchantModel.isNamaValid(text)
            if !isValid && hasInteracted { errorMsg = "Nama wajib diisi (maks 100 karakter), tanpa spasi." }
        case .nomorHp:
            isValid = MerchantModel.isNomorHpValid(text)
            if !isValid && hasInteracted { errorMsg = "Nomor HP harus antara 10-13 digit angka." }
        case .nominal:
            isValid = MerchantModel.isNominalValid(text)
            if !isValid && hasInteracted { errorMsg = "Nominal wajib diisi (maks 16 digit angka)." }
        case .tanggal:
            if text.isEmpty { isValid = true }
            else {
                isValid = (text.count == 10 && MerchantModel.sharedDateFormatter.date(from: text) != nil)
            }
            if !isValid && hasInteracted { errorMsg = "Format tanggal harus yyyy-MM-dd dan valid." }
        case .foto:
            isValid = MerchantModel.isFotoValid(currentPhotoData)
            if !customPhotoErrorMessage.isEmpty {
                isValid = false
                errorMsg = customPhotoErrorMessage
                errorLabel.textColor = .systemRed
            } else {
                errorMsg = "Maksimal 5MB. Format: PNG, JPG, JPEG, HEIF."
                errorLabel.textColor = .gray
            }
        default: break
        }
        
        if field != .foto {
            errorLabel.textColor = .systemRed
        }
        
        errorLabel.text = errorMsg
        errorLabel.alpha = errorMsg.isEmpty ? 0 : 1.0
        if field == .foto {
            errorLabel.alpha = 1.0
        }
        
        saveButton.isEnabled = isValid
        saveButton.alpha = isValid ? 1.0 : 0.5
    }
    
    // MARK: ACTIONS
        @objc private func saveTapped() {
        let field = repository.activeEditField
        let text = textField.text ?? ""
        
        // Save specific field to draft
        if field == .foto {
            repository.draftPhoto = currentPhotoData
        } else {
            switch field {
            case .ktp: repository.draftKtp = text
            case .npwp: repository.draftNpwp = text
            case .nomorRekening: repository.draftNomorRekening = text
            case .namaUsaha: repository.draftNamaUsaha = text
            case .nama: repository.draftNama = text
            case .nomorHp: repository.draftNomorHp = text
            case .nominal: repository.draftNominal = text
            case .tanggal: repository.draftTanggal = text
            default: break
            }
        }
        
        // Construct new master model based on current draft
        let rawNominal = repository.draftNominal.filter { $0.isNumber }
        let rawKtp = repository.draftKtp.filter { $0.isNumber }
        
        let updatedMerchant = MerchantModel(
            ktp: rawKtp,
            npwp: repository.draftNpwp,
            nomorRekening: repository.draftNomorRekening,
            namaUsaha: repository.draftNamaUsaha,
            foto: repository.draftPhoto,
            nama: repository.draftNama,
            nomorHp: repository.draftNomorHp,
            nominal: rawNominal,
            tanggal: MerchantModel.sharedDateFormatter.date(from: repository.draftTanggal)
        )
        
        repository.activeEditField = .none
        navigator.path = [.result(merchant: updatedMerchant)]
    }
    
    // MARK: PHOTO LOGIC (UIKit native)
    @objc private func photoButtonTapped() {
        // Triggers custom bottom sheet
        let sheetVC = PhotoSourceSheetViewController()
        sheetVC.onSelectCamera = { [weak self] in self?.openCamera() }
        sheetVC.onSelectGallery = { [weak self] in self?.openGallery() }
        
        if let sheet = sheetVC.sheetPresentationController {
            if #available(iOS 16.0, *) {
                sheet.detents = [.custom { _ in 250 }, .medium()]
            } else {
                sheet.detents = [.medium()]
            }
            sheet.prefersGrabberVisible = true
        }
        present(sheetVC, animated: true)
    }
    
    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true)
    }
    
    private func openGallery() {
        // Modern gallery engine (faster, can check format)
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // Camera Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        hasInteracted = true
        if let image = info[.originalImage] as? UIImage {
            if let data = image.jpegData(compressionQuality: 1.0) {
                processRawPhotoData(data)
            }
        }
    }
    
    // Modern Gallery Delegate
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        hasInteracted = true
        guard let provider = results.first?.itemProvider else { return }
        
        let allowedTypes: [UTType] = [.jpeg, .png, .heic, .heif]
        guard let typeIdentifier = provider.registeredTypeIdentifiers.first,
              let utType = UTType(typeIdentifier),
              allowedTypes.contains(utType) else {
            DispatchQueue.main.async {
                self.currentPhotoData = nil
                self.customPhotoErrorMessage = "Format tidak didukung. Gunakan PNG, JPG, JPEG, atau HEIF."
                self.updatePhotoUI()
                self.validateForm()
            }
            return
        }
        
        provider.loadDataRepresentation(forTypeIdentifier: typeIdentifier) { data, _ in
            DispatchQueue.main.async {
                if let data = data {
                    self.processRawPhotoData(data)
                } else {
                    self.currentPhotoData = nil
                    self.customPhotoErrorMessage = "Gagal upload foto."
                    self.updatePhotoUI()
                    self.validateForm()
                }
            }
        }
    }
    
    // Photo validation
    private func processRawPhotoData(_ data: Data) {
        if data.count > 5 * 1024 * 1024 {
            currentPhotoData = nil
            customPhotoErrorMessage = "Ukuran file maks 5MB."
        } else {
            currentPhotoData = data
            customPhotoErrorMessage = ""
        }
        updatePhotoUI()
        validateForm()
    }
    
    private func updatePhotoUI() {
        if let data = currentPhotoData, let image = UIImage(data: data) {
            photoImageView.image = image
            photoImageView.isHidden = false
            photoButton.setImage(nil, for: .normal)
        } else {
            photoImageView.isHidden = true
            photoButton.setImage(UIImage(systemName: "camera"), for: .normal)
        }
    }
}

// MARK: Custom Bottom Sheet (SwiftUI replica)
class PhotoSourceSheetViewController: UIViewController {
    var onSelectCamera: (() -> Void)?
    var onSelectGallery: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        // Liquid Glass Background
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(visualEffectView)
        
        let stack = UIStackView()
        
        stack.axis = .vertical
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        let camBtn = createButton(title: "Kamera", icon: "camera", action: #selector(camTapped))
        let galBtn = createButton(title: "Galeri", icon: "photo", action: #selector(galTapped))
        
        stack.addArrangedSubview(camBtn)
        stack.addArrangedSubview(galBtn)
        stack.addArrangedSubview(UIView())
        
        NSLayoutConstraint.activate([
            // Pin visual effect to edges flexibly
            visualEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 35),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // Modern UIButton.Configuration (robust, dynamic padding/alignment)
    private func createButton(title: String, icon: String, action: Selector) -> UIButton {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .secondarySystemGroupedBackground
        btn.layer.cornerRadius = 10
        btn.tintColor = .label
        btn.addTarget(self, action: action, for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: icon)
        config.title = title
        config.imagePadding = 10
        config.baseForegroundColor = .label
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0)
        btn.contentHorizontalAlignment = .left
        btn.configuration = config
        return btn
    }
    
    @objc private func camTapped() {
        dismiss(animated: true) { self.onSelectCamera?() }
    }
    @objc private func galTapped() {
        dismiss(animated: true) { self.onSelectGallery?() }
    }
}
