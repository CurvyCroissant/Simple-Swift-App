//  Features/MerchantDetails/MerchantDetailsView.swift

import UIKit

class MerchantDetailsView: BaseFormView {
    let namaField = ValidatedTextFieldView(title: "Nama", keyboardType: .default)
    let nomorHpField = ValidatedTextFieldView(title: "No HP", keyboardType: .numberPad)
    let nominalField = ValidatedTextFieldView(title: "Nominal", keyboardType: .numberPad, prefix: "Rp")
    let tanggalField = ValidatedTextFieldView(title: "Tanggal", keyboardType: .numberPad)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        formCard.addField(namaField)
        formCard.addField(nomorHpField)
        formCard.addField(nominalField)
        formCard.addField(tanggalField)
        
        submitButton.setTitle("Lanjut", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
