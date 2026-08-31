// Core/MerchantModel.swift

import Foundation

// MARK: DATA MODEL
// Hashable: value-based NavigationStack routing
// Codable: JSON encoding for backend API
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
