// ViewModels/MerchantFormViewModel.swift

import SwiftUI
import Combine

struct ValidatedField {
    var text: String = "" {
        didSet {
            hasInteracted = true
        }
    }
    var hasInteracted: Bool = false
}

class MerchantFormViewModel: ObservableObject {
    @Published var ktp = ValidatedField()
    @Published var npwp = ValidatedField()
    @Published var nomorRekening = ValidatedField()
    @Published var namaUsaha = ValidatedField()
    
    let lengthKtp: Int = 16
    let maxLengthNpwp: Int = 16
    let maxLengthNomorRekening: Int = 16
    let maxLengthNamaUsaha: Int = 23
    
    // Extract raw digits from formatted text
    func rawDigits(_ text: String) -> String {
        return text.filter {
            $0.isNumber
        }
    }
    
    // MARK: VALIDATION CHECKS
    var isKtpValid: Bool {
        let raw = rawDigits(ktp.text)
        return raw.count == lengthKtp
    }
    
    var isNpwpValid: Bool {
        let raw = rawDigits(npwp.text)
        return !raw.isEmpty && raw.count <= maxLengthNpwp
    }
    
    var isNomorRekeningValid: Bool {
        let raw = rawDigits(nomorRekening.text)
        return !raw.isEmpty && raw.count <= maxLengthNomorRekening
    }
    
    var isNamaUsahaValid: Bool {
        if namaUsaha.text.isEmpty {
            return true
        }
        return namaUsaha.text.count <= maxLengthNamaUsaha && !namaUsaha.text.hasPrefix(" ") && !namaUsaha.text.hasSuffix(" ")
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
        return "Tidak boleh diawali atau diakhiri dengan spasi (maks 23 karakter)."
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
