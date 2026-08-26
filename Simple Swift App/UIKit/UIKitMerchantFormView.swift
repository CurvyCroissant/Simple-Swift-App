////
////  UIKitMerchantFormView.swift
////  Simple Swift App
////
////  Created by ITBCA on 19/08/26.
////
//
//import UIKit
//
//class UIKitMerchantFormView: UIView { // custom view that inherits from UIView
//    private lazy var ktpLabel = createLabel(text: "KTP:")
//    lazy var ktpTextField = createTextField() // not private so controller can access
//    lazy var ktpErrorLabel = createErrorLabel(text: getErrorMessage(text: "ktp"))
//    
//    private lazy var npwpLabel = createLabel(text: "NPWP:")
//    lazy var npwpTextField = createTextField()
//    lazy var npwpErrorLabel = createErrorLabel(text: getErrorMessage(text: "npwp"))
//    
//    private lazy var kodePosLabel = createLabel(text: "Kode Pos:")
//    lazy var kodePosTextField = createTextField()
//    lazy var kodePosErrorLabel = createErrorLabel(text: getErrorMessage(text: "kodePos"))
//    
//    private lazy var namaUsahaLabel = createLabel(text: "Nama Usaha di Stiker QRIS:")
//    lazy var namaUsahaTextField = createTextField()
//    lazy var namaUsahaErrorLabel = createErrorLabel(text: getErrorMessage(text: "namaUsaha"))
//    
//    lazy var submitButton = createSubmitButton()
//    
//    // VStack Container for the form
//    private lazy var mainStackView: UIStackView = {
//        let stack = UIStackView()
//        
//        stack.axis = .vertical
//        stack.spacing = 15 // distance between each input group
//        stack.translatesAutoresizingMaskIntoConstraints = false // required to use Auto Layout (only main container needs this)
//        
//        return stack
//    } ()
//    
//    // FACTORY METHODS
//    private func createLabel(text: String) -> UILabel {
//        let label = UILabel()
//        
//        label.text = text
//        label.font = .systemFont(ofSize: 18, weight: .medium)
//        
//        return label
//    }
//    
//    private func createTextField() -> UITextField {
//        let textField = UITextField()
//        
//        textField.borderStyle = .roundedRect
//        
//        // disable text formatting
//        textField.autocorrectionType = .no
//        textField.autocapitalizationType = .none
//        textField.spellCheckingType = .no
//        textField.smartInsertDeleteType = .no
//        textField.smartDashesType = .no
//        textField.smartQuotesType = .no
//        
//        return textField
//    }
//    
//    private func createErrorLabel(text: String) -> UILabel {
//        let label = UILabel()
//        
//        label.text = text
//        label.font = .systemFont(ofSize: 12, weight: .regular)
//        label.textColor = .systemRed
//        label.isHidden = true
//        
//        return label
//    }
//    
//    private func createSubmitButton() -> UIButton {
//        var config = UIButton.Configuration.filled()
//        config.title = "Submit"
//        config.buttonSize = .large
//        
//        let button = UIButton(configuration: config)
//        button.isEnabled = false
//        
//        return button
//    }
//    
//    private func getErrorMessage(text: String) -> String {
//        switch text {
//        case "ktp":
//            return "KTP harus diisi dan maksimal 16 karakter."
//        case "npwp":
//            return "NPWP harus diisi dan maksimal 16 karakter."
//        case "kodePos":
//            return "Kode Pos harus diisi dan maksimal 5 karakter."
//        case "namaUsaha":
//            return "Nama Usaha harus diisi dan maksimal 23 karakter."
//        default:
//            return "Error: Unknown feature."
//        }
//    }
//    
//    private func createInputGroup(label: UILabel, textField: UITextField, errorLabel: UILabel) -> UIStackView {
//        let stack = UIStackView(arrangedSubviews: [label, textField, errorLabel])
//        
//        stack.axis = .vertical
//        stack.spacing = 5 // distance between label and text field
//        
//        return stack
//    }
//    
//    // To organize UI setup code
//    private func setupUI() {
//        backgroundColor = .systemBackground // standard light/dark mode background
//        
//        let ktpGroup = createInputGroup(label: ktpLabel, textField: ktpTextField, errorLabel: ktpErrorLabel)
//        let npwpGroup = createInputGroup(label: npwpLabel, textField: npwpTextField, errorLabel: npwpErrorLabel)
//        let kodePosGroup = createInputGroup(label: kodePosLabel, textField: kodePosTextField, errorLabel: kodePosErrorLabel)
//        let namaUsahaGroup = createInputGroup(label: namaUsahaLabel, textField: namaUsahaTextField, errorLabel: namaUsahaErrorLabel)
//        
//        mainStackView.addArrangedSubview(ktpGroup)
//        mainStackView.addArrangedSubview(npwpGroup)
//        mainStackView.addArrangedSubview(kodePosGroup)
//        mainStackView.addArrangedSubview(namaUsahaGroup)
//        mainStackView.addArrangedSubview(submitButton)
//        
//        addSubview(mainStackView) // add main container to view hierarchy
//        
//        
//        NSLayoutConstraint.activate([ // maps the anchors of our label to the anchor of its parent view
//            mainStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
//            mainStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
//            mainStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20)
//        ])
//    }
//    
//    // BOILERPLATE (for custom UIView subclass)
//    override init(frame: CGRect) { // initializer for programmatic creation. triggered when view is created programmatically thru this view
//        super.init(frame: frame) // calls UIView's initializer to set up basic view.
//        setupUI()
//    }
//    
//    // BOILERPLATE (for custom UIView subclass)
//    required init?(coder: NSCoder) { // must be implemented because UIView conforms to NSCoding protocol.
//        fatalError("init(coder:) has not been implemented") // because storyboards isn't used, this initializer should never be called.
//    }
//}
