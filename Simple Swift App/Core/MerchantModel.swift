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
    
    // MARK: CENTRALIZED FORMATTERS
    static let sharedDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    static let sharedNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter
    }()
    
    // MARK: CENTRALIZED BUSINESS RULES
    static func isKtpValid(_ text: String) -> Bool {
        return text.filter { $0.isNumber }.count == 16
    }
    static func isNpwpValid(_ text: String) -> Bool {
        let count = text.filter { $0.isNumber }.count
        return count > 0 && count <= 16
    }
    static func isNomorRekeningValid(_ text: String) -> Bool {
        let count = text.filter { $0.isNumber }.count
        return count > 0 && count <= 16
    }
    static func isNamaUsahaValid(_ text: String) -> Bool {
        if text.isEmpty {
            return true
        }
        return text.count <= 23 && !text.hasPrefix(" ") && !text.hasSuffix(" ")
    }
    static func isFotoValid(_ foto: Data?) -> Bool {
        return foto != nil
    }
    static func isNamaValid(_ text: String) -> Bool {
        return !text.isEmpty && text.count <= 100 && !text.hasPrefix(" ") && !text.hasSuffix(" ")
    }
    static func isNomorHpValid(_ text: String) -> Bool {
        let count = text.filter { $0.isNumber }.count
        return count == 0 || (count >= 10 && count <= 13)
    }
    static func isNominalValid(_ text: String) -> Bool {
        let count = text.filter { $0.isNumber }.count
        return count > 0 && count <= 16
    }
}
