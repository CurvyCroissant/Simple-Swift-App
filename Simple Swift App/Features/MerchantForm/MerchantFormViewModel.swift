// Features/MerchantForm/MerchantFormViewModel.swift

import SwiftUI
import Combine

class MerchantFormViewModel: ObservableObject {
    @Published var ktp = ValidatedField()
    @Published var npwp = ValidatedField()
    @Published var nomorRekening = ValidatedField()
    @Published var namaUsaha = ValidatedField()
    
    let lengthKtp: Int = 16
    let maxLengthNpwp: Int = 16
    let maxLengthNomorRekening: Int = 16
    let maxLengthNamaUsaha: Int = 23
    
    func reset() {
        ktp = ValidatedField()
        npwp = ValidatedField()
        nomorRekening = ValidatedField()
        namaUsaha = ValidatedField()
    }
    
    // Extract raw digits from formatted text
    func rawDigits(_ text: String) -> String {
        return text.filter {
            $0.isNumber
        }
    }
    
    // MARK: VALIDATION CHECKS
    var isKtpValid: Bool {
        return MerchantModel.isKtpValid(ktp.text)
    }
    
    var isNpwpValid: Bool {
        return MerchantModel.isNpwpValid(npwp.text)
    }
    
    var isNomorRekeningValid: Bool {
        return MerchantModel.isNomorRekeningValid(nomorRekening.text)
    }
    
    var isNamaUsahaValid: Bool {
        return MerchantModel.isNamaUsahaValid(namaUsaha.text)
    }
    
    var canSubmit: Bool {
        isKtpValid && isNpwpValid && isNomorRekeningValid && isNamaUsahaValid
    }
    
    // MARK: ERROR MESSAGES
    func getKtpError() -> String {
        if !ktp.hasInteracted || isKtpValid {
            return ""
        }
        return "KTP wajib diisi (harus 16 digit angka)."
    }
    
    func getNpwpError() -> String {
        if !npwp.hasInteracted || isNpwpValid {
            return ""
        }
        return "NPWP wajib diisi (maks 16 digit angka)."
    }
    
    func getNomorRekeningError() -> String {
        if !nomorRekening.hasInteracted || isNomorRekeningValid {
            return ""
        }
        return "Nomor Rekening wajib diisi (maks 16 digit angka)."
    }
    
    func getNamaUsahaError() -> String {
        if !namaUsaha.hasInteracted || isNamaUsahaValid {
            return ""
        }
        if namaUsaha.text.count > maxLengthNamaUsaha {
            return "Nama Usaha maksimal 23 karakter."
        }
        return "Tidak boleh diawali/diakhiri spasi (maks 23 karakter)."
    }
    
    // MARK: FORMATTER
    func formatKTP(_ text: String) -> String {
        let digits = rawDigits(text)
        let limited = String(digits.prefix(lengthKtp))
        var formatted = ""
        for (index, char) in limited.enumerated() {
            if index != 0 && index % 4 == 0 {
                formatted.append(" ")
            }
            formatted.append(char)
        }
        return formatted
    }
}
