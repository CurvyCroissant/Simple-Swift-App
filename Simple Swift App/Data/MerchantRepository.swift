// Data/MerchantRepository.swift

import Foundation
import Combine

// DATA MODEL
struct MerchantModel: Hashable, Codable {
    let ktp: String
    let npwp: String
    let nomorRekening: String
    let namaUsaha: String
    var foto: Data? = nil
}

// DB MANAGER
class MerchantRepository: ObservableObject {
    // Local in-memory DB
    @Published private(set) var savedMerchants: [MerchantModel] = []
    
    // Temporary cache
    @Published var draftPhoto: Data? = nil
    
    func save(merchant: MerchantModel) {
        savedMerchants.append(merchant)
        
        // Clear cache
        draftPhoto = nil
        
        print("DB Log: Saved Merchant - KTP: \(merchant.ktp), NPWP: \(merchant.npwp), Rek: \(merchant.nomorRekening), Usaha: \(merchant.namaUsaha)")
    }
}
