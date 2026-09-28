//  Features/MerchantForm/MerchantFormViewController.swift

import UIKit

class MerchantFormViewController: BaseFormViewController {
    // MARK: VIEW ACCESS
    private var merchantFormView: MerchantFormView { formView as! MerchantFormView }
    
    private var ktpField: ValidatedTextFieldView { merchantFormView.ktpField }
    private var npwpField: ValidatedTextFieldView { merchantFormView.npwpField }
    private var rekeningField: ValidatedTextFieldView { merchantFormView.rekeningField }
    private var namaUsahaField: ValidatedTextFieldView { merchantFormView.namaUsahaField }
    
    override func makeFormView() -> BaseFormView {
        MerchantFormView()
    }
    
    // MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Registrasi 1/3"
        
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        setupBindings()
        validateForm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let repo = MerchantRepository.shared
        let isDraftEmpty = repo.draftKtp.isEmpty && repo.draftNpwp.isEmpty && repo.draftNomorRekening.isEmpty && repo.draftNamaUsaha.isEmpty
        
        // like SwiftUI's .onAppear
        if isDraftEmpty && repo.activeEditField == .none {
            ktpField.textField.text = ""
            ktpField.resetInteraction()
            npwpField.textField.text = ""
            npwpField.resetInteraction()
            rekeningField.textField.text = ""
            rekeningField.resetInteraction()
            namaUsahaField.textField.text = ""
            namaUsahaField.resetInteraction()
        } else {
            ktpField.textField.text = repo.draftKtp
            npwpField.textField.text = repo.draftNpwp
            rekeningField.textField.text = repo.draftNomorRekening
            namaUsahaField.textField.text = repo.draftNamaUsaha
        }
        validateForm()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // like SwiftUI's .onDisappear
        let repo = MerchantRepository.shared
        repo.draftKtp = ktpField.textField.text ?? ""
        repo.draftNpwp = npwpField.textField.text ?? ""
        repo.draftNomorRekening = rekeningField.textField.text ?? ""
        repo.draftNamaUsaha = namaUsahaField.textField.text ?? ""
    }
    
    // MARK: CUSTOM LOGIC & BINDINGS
    private func setupBindings() {
        ktpField.onTextChange = { [weak self] text in
            guard let self = self else {
                return
            }
            
            // format KTP
            let digits = String(text.filter { $0.isNumber }.prefix(16))
            var formatted = ""
            for (index, char) in digits.enumerated() {
                if index != 0 && index % 4 == 0 {
                    formatted.append(" ")
                }
                formatted.append(char)
            }
            
            if self.ktpField.textField.text != formatted {
                self.ktpField.textField.text = formatted
            }
            self.validateForm()
        }
        
        npwpField.onTextChange = { [weak self] text in
            guard let self = self else {
                return
            }
            let digits = String(text.filter { $0.isNumber }.prefix(16))
            if self.npwpField.textField.text != digits {
                self.npwpField.textField.text = digits
            }
            self.validateForm()
        }
        
        rekeningField.onTextChange = { [weak self] text in
            guard let self = self else {
                return
            }
            let digits = String(text.filter { $0.isNumber }.prefix(16))
            if self.rekeningField.textField.text != digits {
                self.rekeningField.textField.text = digits
            }
            self.validateForm()
        }
        
        namaUsahaField.onTextChange = { [weak self] text in
            guard let self = self else {
                return
            }
            let formatted = String(text.prefix(23))
            if self.namaUsahaField.textField.text != formatted {
                self.namaUsahaField.textField.text = formatted
            }
            self.validateForm()
        }
    }
    
    private func validateForm() {
        let isKtpValid = MerchantModel.isKtpValid(ktpField.textField.text ?? "")
        let isNpwpValid = MerchantModel.isNpwpValid(npwpField.textField.text ?? "")
        let isRekeningValid = MerchantModel.isNomorRekeningValid(rekeningField.textField.text ?? "")
        let isNamaUsahaValid = MerchantModel.isNamaUsahaValid(namaUsahaField.textField.text ?? "")
        
        if ktpField.hasInteracted {
            ktpField.updateError(isKtpValid ? "" : "KTP wajib diisi (harus 16 digit angka).")
        }
        if npwpField.hasInteracted {
            npwpField.updateError(isNpwpValid ? "" : "NPWP wajib diisi (maks 16 digit angka).")
        }
        if rekeningField.hasInteracted {
            rekeningField.updateError(isRekeningValid ? "" : "Nomor Rekening wajib diisi (maks 16 digit angka).")
        }
        if namaUsahaField.hasInteracted {
            namaUsahaField.updateError(isNamaUsahaValid ? "" : "Maks 23 karakter, tanpa spasi di awal/akhir.")
        }
        
        let isValid = isKtpValid && isNpwpValid && isRekeningValid && isNamaUsahaValid
        submitButton.isEnabled = isValid
        submitButton.alpha = isValid ? 1.0 : 0.5
    }
    
    @objc private func submitTapped() {
        let repo = MerchantRepository.shared
        
        // extract raw digits for final model
        let rawKtp = (ktpField.textField.text ?? "").filter { $0.isNumber }
        let rawNominal = repo.draftNominal.filter { $0.isNumber }
        
        let newMerchant = MerchantModel(
            ktp: rawKtp,
            npwp: npwpField.textField.text ?? "",
            nomorRekening: rekeningField.textField.text ?? "",
            namaUsaha: namaUsahaField.textField.text ?? "",
            foto: repo.draftPhoto,
            nama: repo.draftNama,
            nomorHp: repo.draftNomorHp,
            nominal: rawNominal,
            tanggal: MerchantModel.sharedDateFormatter.date(from: repo.draftTanggal)
        )
        
        if repo.activeEditField != .none {
            repo.activeEditField = .none
            Navigator.shared.returnToResult(with: newMerchant)
        } else {
            Navigator.shared.showMerchantPhoto(for: newMerchant)
        }
    }
}
