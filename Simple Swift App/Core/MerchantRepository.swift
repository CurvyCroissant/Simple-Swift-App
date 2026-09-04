// Core/MerchantRepository.swift

import Foundation

enum EditField: Equatable {
    case none, ktp, npwp, nomorRekening, namaUsaha, foto, nama, nomorHp, nominal, tanggal
}

// MARK: DB MANAGER
class MerchantRepository {
    // MARK: SINGLETON INSTANCE
    static let shared = MerchantRepository()
    
    private init() {}
    
    // local in-memory DB
    private(set) var savedMerchants: [MerchantModel] = []
    
    var activeEditField: EditField = .none
    
    // save draft
    var draftKtp = ""
    var draftNpwp = ""
    var draftNomorRekening = ""
    var draftNamaUsaha = ""
    var draftPhoto: Data? = nil
    var draftNama = ""
    var draftNomorHp = ""
    var draftNominal = ""
    var draftTanggal = ""
    
    func save(merchant: MerchantModel) {
        savedMerchants.append(merchant)
        
        // clear draft when submitted
        draftKtp = ""
        draftNpwp = ""
        draftNomorRekening = ""
        draftNamaUsaha = ""
        draftPhoto = nil
        draftNama = ""
        draftNomorHp = ""
        draftNominal = ""
        draftTanggal = ""
        
        // terminal logs
        let fotoStatus = merchant.foto != nil ? "true" : "false"
        let tanggalStr = merchant.tanggal != nil ? MerchantModel.sharedDateFormatter.string(from: merchant.tanggal!) : "Kosong"
        print("LOG: Successfully saved merchant. ktp: \(merchant.ktp), npwp: \(merchant.npwp), nomorRekening: \(merchant.nomorRekening), namaUsaha: \(merchant.namaUsaha), foto: \(fotoStatus), nama: \(merchant.nama), nomorHp: \(merchant.nomorHp), nominal: \(merchant.nominal), tanggal: \(tanggalStr)")
    }
    
    func reset() {
        savedMerchants.removeAll()
        
        draftKtp = ""
        draftNpwp = ""
        draftNomorRekening = ""
        draftNamaUsaha = ""
        draftPhoto = nil
        draftNama = ""
        draftNomorHp = ""
        draftNominal = ""
        draftTanggal = ""
        
        activeEditField = .none
        
        print("LOG: Repository completely reset.")
    }
}
