//  Features/MerchantDetails/MerchantDetailsViewModel.swift

import SwiftUI
import Combine

class MerchantDetailsViewModel: ObservableObject {
    @Published var nama = ValidatedField()
    @Published var nomorHp = ValidatedField()
    @Published var nominal = ValidatedField()
    @Published var tanggal = ValidatedField()
    
    let maxLengthNama = 100
    let maxLengthNominal = 16
    
    func formatAlphanumeric(_ text: String) -> String {
        return String(text.filter {
            $0.isLetter || $0.isNumber || $0.isWhitespace
        }
            .prefix(maxLengthNama))
    }
    
    func rawDigits(_ text: String) -> String {
        return text.filter {
            $0.isNumber
        }
    }
    
    func formatRupiah(_ text: String) -> String {
        let digits = String(rawDigits(text).prefix(maxLengthNominal))
        if digits.isEmpty {
            return ""
        }
        guard let number = Int64(digits) else {
            return digits
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: number)) ?? digits
    }
    
    func formatTanggalInput(_ text: String) -> String {
        let digits = String(rawDigits(text).prefix(8))
        var formatted = ""
        for (index, char) in digits.enumerated() {
            if index == 4 || index == 6 {
                formatted.append("-")
            }
            formatted.append(char)
        }
        return formatted
    }
    
    func parseTanggal(_ text: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: text)
    }
    
    // MARK: VALIDATION
    var isNamaValid: Bool {
        !nama.text.isEmpty && !nama.text.hasPrefix(" ") && !nama.text.hasSuffix(" ") && nama.text.count <= maxLengthNama
    }
    
    var isNomorHpValid: Bool {
        let digits = rawDigits(nomorHp.text)
        return digits.isEmpty || (digits.count >= 10 && digits.count <= 13)
    }
    
    var isNominalValid: Bool {
        !nominal.text.isEmpty && rawDigits(nominal.text).count <= maxLengthNominal
    }
    
    var isTanggalValid: Bool {
        if tanggal.text.isEmpty { return true }
        if tanggal.text.count != 10 { return false }
        return parseTanggal(tanggal.text) != nil
    }
    
    var canSubmit: Bool {
        isNamaValid && isNomorHpValid && isNominalValid && isTanggalValid
    }
    
    // MARK: ERROR MESSAGES
    func getNamaError() -> String {
        if !nama.hasInteracted || isNamaValid {
            return ""
        }
        if nama.text.isEmpty {
            return "Nama wajib diisi (maks 100 karakter)."
        }
        return "Tidak boleh diawali/diakhiri spasi."
    }
    
    func getNomorHpError() -> String {
        if !nomorHp.hasInteracted || isNomorHpValid {
            return ""
        }
        return "Nomor HP harus antara 10-13 digit angka."
    }
    
    func getNominalError() -> String {
        if !nominal.hasInteracted || isNominalValid {
            return ""
        }
        return "Nominal wajib diisi (maks 16 digit angka)."
    }
    
    func getTanggalError() -> String {
        if !tanggal.hasInteracted || isTanggalValid {
            return ""
        }
        return "Format tanggal harus yyyy-MM-dd dan valid."
    }
}
