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
    
    let maxLengthKtp: Int = 16
    let maxLengthNpwp: Int = 16
    let maxLengthNomorRekening: Int = 5
    let maxLengthNamaUsaha: Int = 23
    
    func isFieldEmpty(text: String) -> Bool {
        text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    func isWithinLimit(text: String, n: Int) -> Bool {
        text.count <= n
    }
    func getErrorMessage(field: ValidatedField, text: String, n: Int, isValid: Bool) -> String {
        if !field.hasInteracted || isValid {
            return ""
        }
        
        return "\(text) tidak boleh kosong atau lebih dari \(n) karakter"
    }
    
    var isKtpValid: Bool {
        !isFieldEmpty(text: ktp.text) && isWithinLimit(text: ktp.text, n: maxLengthKtp)
    }
    var isNpwpValid: Bool {
        !isFieldEmpty(text: npwp.text) && isWithinLimit(text: npwp.text, n: maxLengthNpwp)
    }
    var isNomorRekeningValid: Bool {
        !isFieldEmpty(text: nomorRekening.text) && isWithinLimit(text: nomorRekening.text, n: maxLengthNomorRekening)
    }
    var isNamaUsahaValid: Bool {
        !isFieldEmpty(text: namaUsaha.text) && isWithinLimit(text: namaUsaha.text, n: maxLengthNamaUsaha)
    }
    
    var canSubmit: Bool {
        isKtpValid && isNpwpValid && isNomorRekeningValid && isNamaUsahaValid
    }
}
