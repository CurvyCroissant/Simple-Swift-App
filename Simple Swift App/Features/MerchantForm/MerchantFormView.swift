//  Features/MerchantForm/MerchantFormView.swift

import UIKit

class MerchantFormView: BaseFormView {
    let ktpField = ValidatedTextFieldView(title: "No KTP", keyboardType: .numberPad)
    let npwpField = ValidatedTextFieldView(title: "NPWP", keyboardType: .numberPad)
    let rekeningField = ValidatedTextFieldView(title: "No Rekening", keyboardType: .numberPad)
    let namaUsahaField = ValidatedTextFieldView(title: "Nama Usaha di Stiker QRIS", keyboardType: .default)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        formCard.addField(ktpField)
        formCard.addField(npwpField)
        formCard.addField(rekeningField)
        formCard.addField(namaUsahaField)
        
        submitButton.setTitle("Lanjut", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
