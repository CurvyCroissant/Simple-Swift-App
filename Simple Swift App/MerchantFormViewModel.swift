//
//  MerchantFormViewModel.swift
//  Simple Swift App
//
//  Created by ITBCA on 19/08/26.
//

import SwiftUI
import Combine

// checks if an input field has been interacted with by the user or not
struct ValidatedField {
    var text: String = "" {
        didSet {
            hasInteracted = true
        }
    }
    var hasInteracted: Bool = false
}

// "ObservableObject", protocol so that the class can be observed by Views. Usually has "@Published" properties for triggering View updates when changed
class MerchantFormViewModel: ObservableObject {
    
    // "@Published", when its value changes, all Views observing that object are updated.
    @Published var ktp = ValidatedField()
    @Published var npwp = ValidatedField()
    @Published var kodePos = ValidatedField()
    @Published var namaUsaha = ValidatedField()
    
    let maxLengthKtp: Int = 16
    let maxLengthNpwp: Int = 16
    let maxLengthKodePos: Int = 5
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
    var isKodePosValid: Bool {
        !isFieldEmpty(text: kodePos.text) && isWithinLimit(text: kodePos.text, n: maxLengthKodePos)
    }
    var isNamaUsahaValid: Bool {
        !isFieldEmpty(text: namaUsaha.text) && isWithinLimit(text: namaUsaha.text, n: maxLengthNamaUsaha)
    }
    
    var canSubmit: Bool {
        isKtpValid && isNpwpValid && isKodePosValid && isNamaUsahaValid
    }
}
