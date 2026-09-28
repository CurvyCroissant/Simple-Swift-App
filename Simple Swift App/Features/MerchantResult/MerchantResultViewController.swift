//  Features/MerchantResult/MerchantResultViewController.swift

import UIKit

class MerchantResultViewController: BaseFormViewController {
    var merchant: MerchantModel!
    
    private var resultView: MerchantResultView { formView as! MerchantResultView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profil Pengguna"
        navigationItem.hidesBackButton = true
        
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        populateRows()
        validateForm()
    }
    
    // MARK: DATA REFRESH
    func update(with merchant: MerchantModel) {
        self.merchant = merchant
        
        if isViewLoaded {
            populateRows()
            validateForm()
        }
    }
    
    // MARK: PRESENTATION LOGIC
    private var displayKTP: String {
        var formatted = ""
        
        for (index, char) in merchant.ktp.enumerated() {
            if index != 0 && index % 4 == 0 {
                formatted.append(" ")
            }
            formatted.append(char)
        }
        return formatted
    }
    
    private var displayNominal: String {
        guard let number = Int64(merchant.nominal) else {
            return merchant.nominal
        }
        return MerchantModel.sharedNumberFormatter.string(from: NSNumber(value: number)) ?? merchant.nominal
    }
    
    private var displayTanggal: String {
        guard let date = merchant.tanggal else {
            return "-"
        }
        return MerchantModel.sharedDateFormatter.string(from: date)
    }
    
    private var draftTanggal: String {
        guard let date = merchant.tanggal else {
            return ""
        }
        return MerchantModel.sharedDateFormatter.string(from: date)
    }
    
    private var displayNamaUsaha: String {
        merchant.namaUsaha.isEmpty ? "-" : merchant.namaUsaha
    }
    
    private var displayNomorHp: String {
        merchant.nomorHp.isEmpty ? "-" : merchant.nomorHp
    }
    
    // MARK: ROW SETUP
    private func populateRows() {
        resultView.ktpRow.configure(title: "No KTP", value: displayKTP)
        resultView.ktpRow.onEditTap = { [weak self] in self?.triggerEdit(.ktp) }
        
        resultView.namaRow.configure(title: "Nama", value: merchant.nama)
        resultView.namaRow.onEditTap = { [weak self] in self?.triggerEdit(.nama) }
        
        resultView.npwpRow.configure(title: "NPWP", value: merchant.npwp)
        resultView.npwpRow.onEditTap = { [weak self] in self?.triggerEdit(.npwp) }
        
        resultView.rekeningRow.configure(title: "No Rekening", value: merchant.nomorRekening)
        resultView.rekeningRow.onEditTap = { [weak self] in self?.triggerEdit(.nomorRekening) }
        
        resultView.nomorHpRow.configure(title: "No HP", value: displayNomorHp)
        resultView.nomorHpRow.onEditTap = { [weak self] in self?.triggerEdit(.nomorHp) }
        
        resultView.tanggalRow.configure(title: "Tanggal", value: displayTanggal)
        resultView.tanggalRow.onEditTap = { [weak self] in self?.triggerEdit(.tanggal) }
        
        resultView.nominalRow.configure(title: "Nominal", value: "Rp \(displayNominal)")
        resultView.nominalRow.onEditTap = { [weak self] in self?.triggerEdit(.nominal) }
        
        resultView.fotoRow.configure(title: "Foto", image: merchant.foto.flatMap { UIImage(data: $0) })
        resultView.fotoRow.onEditTap = { [weak self] in self?.triggerEdit(.foto) }
        
        resultView.namaUsahaRow.configure(title: "Nama Usaha di Stiker QRIS", value: displayNamaUsaha)
        resultView.namaUsahaRow.onEditTap = { [weak self] in self?.triggerEdit(.namaUsaha) }
    }
    
    // MARK: VALIDATION
    private func validateForm() {
        let isValid = MerchantModel.isKtpValid(merchant.ktp)
        && MerchantModel.isNpwpValid(merchant.npwp)
        && MerchantModel.isNamaValid(merchant.nama)
        && MerchantModel.isNamaUsahaValid(merchant.namaUsaha)
        && MerchantModel.isNomorRekeningValid(merchant.nomorRekening)
        && MerchantModel.isFotoValid(merchant.foto)
        && MerchantModel.isNominalValid(merchant.nominal)
        && MerchantModel.isNomorHpValid(merchant.nomorHp)
        
        submitButton.isEnabled = isValid
        submitButton.alpha = isValid ? 1 : 0.5
    }
    
    // MARK: ACTIONS
    private func triggerEdit(_ field: EditField) {
        let repo = MerchantRepository.shared
        repo.draftKtp = displayKTP
        repo.draftNpwp = merchant.npwp
        repo.draftNomorRekening = merchant.nomorRekening
        repo.draftNamaUsaha = merchant.namaUsaha
        repo.draftPhoto = merchant.foto
        repo.draftNama = merchant.nama
        repo.draftNomorHp = merchant.nomorHp
        repo.draftNominal = displayNominal
        repo.draftTanggal = draftTanggal
        repo.activeEditField = field
        
        Navigator.shared.showEditField(for: merchant, field: field)
    }
    
    @objc private func submitTapped() {
        MerchantRepository.shared.reset()
        Navigator.shared.popToRoot()
    }
}
