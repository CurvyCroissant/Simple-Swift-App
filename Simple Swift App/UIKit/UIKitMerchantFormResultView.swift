//
//  UIKitMerchantFormResultView.swift
//  Simple Swift App
//
//  Created by ITBCA on 21/08/26.
//

import UIKit

class UIKitMerchantFormResultView: UIView {
    private lazy var ktpLabel = createLabel(text: "KTP:")
    private lazy var ktpValueLabel = createLabel(text: "N/A")
    
    private lazy var npwpLabel = createLabel(text: "NPWP:")
    private lazy var npwpValueLabel = createLabel(text: "N/A")
    
    private lazy var kodePosLabel = createLabel(text: "Kode Pos:")
    private lazy var kodePosValueLabel = createLabel(text: "N/A")
    
    private lazy var namaUsahaLabel = createLabel(text: "Nama Usaha di Stiker QRIS:")
    private lazy var namaUsahaValueLabel = createLabel(text: "N/A")
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        
        stack.axis = .vertical
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    } ()
    
    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        
        label.text = text
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0 // allows text to wrap to the next line if too long
        
        return label
    }
    
    private func createInputGroup(titleLabel: UILabel, valueLabel: UILabel) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        
        stack.axis = .vertical
        stack.spacing = 5
        
        return stack
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        let ktpGroup = createInputGroup(titleLabel: ktpLabel, valueLabel: ktpValueLabel)
        let npwpGroup = createInputGroup(titleLabel: npwpLabel, valueLabel: npwpValueLabel)
        let kodePosGroup = createInputGroup(titleLabel: kodePosLabel, valueLabel: kodePosValueLabel)
        let namaUsahaGroup = createInputGroup(titleLabel: namaUsahaLabel, valueLabel: namaUsahaValueLabel)
        
        mainStackView.addArrangedSubview(ktpGroup)
        mainStackView.addArrangedSubview(npwpGroup)
        mainStackView.addArrangedSubview(kodePosGroup)
        mainStackView.addArrangedSubview(namaUsahaGroup)
        
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            mainStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    // configuration method so controller can pass data into this view
    func configure(ktp: String, npwp: String, kodePos: String, namaUsaha: String) {
        ktpValueLabel.text = ktp
        npwpValueLabel.text = npwp
        kodePosValueLabel.text = kodePos
        namaUsahaValueLabel.text = namaUsaha
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
