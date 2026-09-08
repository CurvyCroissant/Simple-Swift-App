//  Features/MerchantDetails/MerchantDetailsViewController.swift

import UIKit

class MerchantDetailsViewController: BaseFormViewController {
    var merchant: MerchantModel?
    
    // MARK: VIEW ACCESS
    private var detailsView: MerchantDetailsView { formView as! MerchantDetailsView }
    
    private var namaField: ValidatedTextFieldView { detailsView.namaField }
    private var nomorHpField: ValidatedTextFieldView { detailsView.nomorHpField }
    private var nominalField: ValidatedTextFieldView { detailsView.nominalField }
    private var tanggalField: ValidatedTextFieldView { detailsView.tanggalField }
    
    override func makeFormView() -> BaseFormView {
        MerchantDetailsView()
    }
    
    // MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Registrasi 3/3"
        
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        setupBindings()
        validateForm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let repo = MerchantRepository.shared
        
        if (namaField.textField.text ?? "").isEmpty || repo.activeEditField != .none {
            namaField.textField.text = repo.draftNama
            nomorHpField.textField.text = repo.draftNomorHp
            nominalField.textField.text = repo.draftNominal
            tanggalField.textField.text = repo.draftTanggal
        }
        validateForm()
    }
    
    // MARK: CUSTOM LOGIC & BINDINGS
    private func setupBindings() {
        namaField.onTextChange = { [weak self] text in
            guard let self = self else {
                return
            }
            
            let formatted = String(text.filter { $0.isLetter || $0.isNumber || $0.isWhitespace }.prefix(100))
            
            if self.namaField.textField.text != formatted {
                self.namaField.textField.text = formatted
            }
            
            MerchantRepository.shared.draftNama = formatted
            self.validateForm()
        }
        
        nomorHpField.onTextChange = { [weak self] text in
            guard let self = self else {
                return
            }
            
            let digits = String(text.filter { $0.isNumber }.prefix(13))
            
            if self.nomorHpField.textField.text != digits {
                self.nomorHpField.textField.text = digits
            }
            
            MerchantRepository.shared.draftNomorHp = digits
            self.validateForm()
        }
        
        nominalField.onTextChange = { [weak self] text in
            guard let self = self else {
                return
            }
            
            let digits = String(text.filter { $0.isNumber }.prefix(16))
            let formatted: String
            
            if digits.isEmpty {
                formatted = ""
            } else if let number = Int64(digits) {
                formatted = MerchantModel.sharedNumberFormatter.string(from: NSNumber(value: number)) ?? digits
            } else {
                formatted = digits
            }
            
            if self.nominalField.textField.text != formatted {
                self.nominalField.textField.text = formatted
            }
            
            MerchantRepository.shared.draftNominal = formatted
            self.validateForm()
        }
        
        tanggalField.onTextChange = { [weak self] text in
            guard let self = self else {
                return
            }
            
            let digits = String(text.filter { $0.isNumber }.prefix(8))
            var formatted = ""
            
            for (index, char) in digits.enumerated() {
                if index == 4 || index == 6 {
                    formatted.append("-")
                }
                formatted.append(char)
            }
            
            if self.tanggalField.textField.text != formatted {
               self.tanggalField.textField.text = formatted
            }
            
            MerchantRepository.shared.draftTanggal = formatted
            self.validateForm()
        }
    }
    
    private func validateForm() {
        let isNamaValid = MerchantModel.isNamaValid(namaField.textField.text ?? "")
        let isNomorHpValid = MerchantModel.isNomorHpValid(nomorHpField.textField.text ?? "")
        let isNominalValid = MerchantModel.isNominalValid(nominalField.textField.text ?? "")
        let isTanggalValid = MerchantModel.isTanggalValid(tanggalField.textField.text ?? "")
        
        if namaField.hasInteracted {
            let namaText = namaField.textField.text ?? ""
            namaField.updateError(isNamaValid ? "" : (namaText.isEmpty ? "Nama wajib diisi (maks 100 karakter)." : "Tidak boleh diawali/diakhiri spasi."))
        }
        if nomorHpField.hasInteracted {
            nomorHpField.updateError(isNomorHpValid ? "" : "Nomor HP harus antara 10-13 digit angka.")
        }
        if nominalField.hasInteracted {
            nominalField.updateError(isNominalValid ? "" : "Nominal wajib diisi (maks 16 digit angka).")
        }
        if tanggalField.hasInteracted {
            tanggalField.updateError(isTanggalValid ? "" : "Format tanggal harus yyyy-MM-dd dan valid.")
        }
        
        let isValid = isNamaValid && isNomorHpValid && isNominalValid && isTanggalValid
        submitButton.isEnabled = isValid
        submitButton.alpha = isValid ? 1 : 0.5
    }
    
    @objc private func submitTapped() {
        guard var finalMerchant = merchant else {
            return
        }
        
        let repo = MerchantRepository.shared
        
        finalMerchant.nama = namaField.textField.text ?? ""
        finalMerchant.nomorHp = (nomorHpField.textField.text ?? "").filter { $0.isNumber }
        finalMerchant.nominal = (nominalField.textField.text ?? "").filter { $0.isNumber }
        finalMerchant.tanggal = MerchantModel.sharedDateFormatter.date(from: tanggalField.textField.text ?? "")
        
        repo.save(merchant: finalMerchant)
        Navigator.shared.showMerchantResult(for: finalMerchant)
    }
}
