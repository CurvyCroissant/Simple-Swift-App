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
        return MerchantModel.sharedNumberFormatter.string(from: NSNumber(value: number)) ?? merchant.nominal
    }
    
    var displayTanggal: String {
        guard let date = merchant.tanggal else {
            return "-"
        }
        return MerchantModel.sharedDateFormatter.string(from: date)
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
        return MerchantModel.sharedDateFormatter.string(from: date)
    }
    
    var draftNamaUsaha: String {
        return merchant.namaUsaha
    }
    
    var draftNomorHp: String {
        return merchant.nomorHp
    }
    
    // MARK: VALIDATION LOGIC
    var isDataValid: Bool {
        return MerchantModel.isKtpValid(merchant.ktp) &&
               MerchantModel.isNpwpValid(merchant.npwp) &&
               MerchantModel.isNomorRekeningValid(merchant.nomorRekening) &&
               MerchantModel.isNamaUsahaValid(merchant.namaUsaha) &&
               MerchantModel.isFotoValid(merchant.foto) &&
               MerchantModel.isNamaValid(merchant.nama) &&
               MerchantModel.isNomorHpValid(merchant.nomorHp) &&
               MerchantModel.isNominalValid(merchant.nominal)
    }
}
