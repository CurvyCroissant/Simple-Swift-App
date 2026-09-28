//  Features/MerchantResult/MerchantResultView.swift

import UIKit

class MerchantResultView: BaseFormView {
    let ktpRow = EditRowView()
    let namaRow = EditRowView()
    let npwpRow = EditRowView()
    let rekeningRow = EditRowView()
    let nomorHpRow = EditRowView()
    let tanggalRow = EditRowView()
    let nominalRow = EditRowView()
    let fotoRow = PhotoEditRowView()
    let namaUsahaRow = EditRowView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        formCard.addField(ktpRow)
        formCard.addField(namaRow)
        formCard.addField(npwpRow)
        formCard.addField(rekeningRow)
        formCard.addField(nomorHpRow)
        formCard.addField(tanggalRow)
        formCard.addField(nominalRow)
        formCard.addField(fotoRow)
        formCard.addField(namaUsahaRow)
        
        submitButton.setTitle("Lanjut", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
