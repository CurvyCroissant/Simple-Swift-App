// Data/MerchantRepository.swift

import Foundation
import Combine

// MARK: DATA MODEL
struct MerchantModel: Hashable, Codable {
    
    // MerchantFormView
    let ktp: String
    let npwp: String
    let nomorRekening: String
    let namaUsaha: String
    
    // MerchantPhotoView
    var foto: Data? = nil
    
    // MerchantDetailsView
    var nama: String = ""
    var nomorHp: String = ""
    var nominal: String = ""
    var tanggal: Date? = nil
}

// MARK: DB MANAGER
class MerchantRepository: ObservableObject {
    // Local in-memory DB
    @Published private(set) var savedMerchants: [MerchantModel] = []
    
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
        
        let fotoStatus = merchant.foto != nil ? "true" : "false"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let tanggalStr = merchant.tanggal != nil ? formatter.string(from: merchant.tanggal!) : "Kosong"
        
        print("LOG: Successfully saved merchant! ktp: \(merchant.ktp), npwp: \(merchant.npwp), nomorRekening: \(merchant.nomorRekening), namaUsaha: \(merchant.namaUsaha), foto: \(fotoStatus), nama: \(merchant.nama), nomorHp: \(merchant.nomorHp), nominal: \(merchant.nominal), tanggal: \(tanggalStr)")
    }
}
