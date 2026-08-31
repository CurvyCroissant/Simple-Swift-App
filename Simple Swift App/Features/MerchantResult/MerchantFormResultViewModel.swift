// Features/MerchantResult/MerchantFormResultViewModel.swift

import SwiftUI

struct MerchantFormResultViewModel {
    let merchant: MerchantModel
    
    // MARK: PRESENTATION LOGIC
    var displayKTP: String {
        var formatted = ""
        for (index, char) in merchant.ktp.enumerated() {
            if index != 0 && index % 4 == 0 {
                formatted.append(" ")
            }
            formatted.append(char)
        }
        return formatted
    }
    
    var displayNominal: String {
        guard let number = Int64(merchant.nominal) else {
            return merchant.nominal
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: number)) ?? merchant.nominal
    }
    
    var displayTanggal: String {
        guard let date = merchant.tanggal else {
            return "-"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    var displayNamaUsaha: String {
        return merchant.namaUsaha.isEmpty ? "-" : merchant.namaUsaha
    }
    
    var displayNomorHp: String {
        return merchant.nomorHp.isEmpty ? "-" : merchant.nomorHp
    }
    
    // MARK: DRAFT RESTORATION
    var draftTanggal: String {
        guard let date = merchant.tanggal else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    var draftNamaUsaha: String {
        return merchant.namaUsaha
    }
    
    var draftNomorHp: String {
        return merchant.nomorHp
    }
    
    // MARK: VALIDATION LOGIC
    var isDataValid: Bool {
        let isKtpValid = merchant.ktp.count == 16
        let isNpwpValid = !merchant.npwp.isEmpty && merchant.npwp.count <= 16
        let isRekeningValid = !merchant.nomorRekening.isEmpty && merchant.nomorRekening.count <= 16
        let isNamaUsahaValid = merchant.namaUsaha.isEmpty || (merchant.namaUsaha.count <= 23 && !merchant.namaUsaha.hasPrefix(" ") && !merchant.namaUsaha.hasSuffix(" "))
        let isFotoValid = merchant.foto != nil
        let isNamaValid = !merchant.nama.isEmpty && merchant.nama.count <= 100 && !merchant.nama.hasPrefix(" ") && !merchant.nama.hasSuffix(" ")
        let isNomorHpValid = merchant.nomorHp.isEmpty || (merchant.nomorHp.count >= 10 && merchant.nomorHp.count <= 13)
        let isNominalValid = !merchant.nominal.isEmpty && merchant.nominal.count <= 16
        
        return isKtpValid && isNpwpValid && isRekeningValid && isNamaUsahaValid && isFotoValid && isNamaValid && isNomorHpValid && isNominalValid
    }
}
