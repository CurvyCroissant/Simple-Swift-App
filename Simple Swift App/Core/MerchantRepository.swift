// Core/MerchantRepository.swift

import Foundation
import Combine

enum EditField: Equatable {
    case none, ktp, npwp, nomorRekening, namaUsaha, foto, nama, nomorHp, nominal, tanggal
}

// MARK: DB MANAGER
class MerchantRepository: ObservableObject {
    // Local in-memory DB
    @Published private(set) var savedMerchants: [MerchantModel] = []
    
    @Published var activeEditField: EditField = .none
    
    // Save user draft
    @Published var draftKtp = ""
    @Published var draftNpwp = ""
    @Published var draftNomorRekening = ""
    @Published var draftNamaUsaha = ""
    @Published var draftPhoto: Data? = nil
    @Published var draftNama = ""
    @Published var draftNomorHp = ""
    @Published var draftNominal = ""
    @Published var draftTanggal = ""
    
    func save(merchant: MerchantModel) {
        savedMerchants.append(merchant)
        
        // Clear all draft when submitted
        draftPhoto = nil
        draftKtp = ""
        draftNpwp = ""
        draftNomorRekening = ""
        draftNamaUsaha = ""
        draftNama = ""
        draftNomorHp = ""
        draftNominal = ""
        draftTanggal = ""
        
        // LOGS
        let fotoStatus = merchant.foto != nil ? "true" : "false"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let tanggalStr = merchant.tanggal != nil ? formatter.string(from: merchant.tanggal!) : "Kosong"
        
        print("LOG: Successfully saved merchant. ktp: \(merchant.ktp), npwp: \(merchant.npwp), nomorRekening: \(merchant.nomorRekening), namaUsaha: \(merchant.namaUsaha), foto: \(fotoStatus), nama: \(merchant.nama), nomorHp: \(merchant.nomorHp), nominal: \(merchant.nominal), tanggal: \(tanggalStr)")
    }
    
    func reset() {
        savedMerchants.removeAll()
        
        draftPhoto = nil
        draftKtp = ""
        draftNpwp = ""
        draftNomorRekening = ""
        draftNamaUsaha = ""
        draftNama = ""
        draftNomorHp = ""
        draftNominal = ""
        draftTanggal = ""
        
        activeEditField = .none
        
        print("LOG: Repository completely reset.")
    }
}
