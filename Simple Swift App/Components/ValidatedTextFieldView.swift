//  Components/ValidatedTextFieldView.swift

import UIKit

class ValidatedTextFieldView: UIView {
    // MARK: CUSTOM
    let titleLabel = UILabel()
    let prefixLabel = UILabel()
    let textField = UITextField()
    let errorLabel = UILabel()
    
    private(set) var hasInteracted = false
    
    // like SwiftUI's @Binding
    var onTextChange: ((String) -> Void)?
    
    init(title: String, keyboardType: UIKeyboardType = .default, prefix: String? = nil) {
        super.init(frame: .zero)
        setupLayout(title: title, keyboardType:keyboardType, prefix: prefix)
        setupActions()
    }
    
    private func setupLayout(title: String, keyboardType: UIKeyboardType, prefix: String?) {
        // title
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 17, weight: .heavy)
        titleLabel.textColor = UIColor(red: 0.09, green: 0.36, blue: 0.62, alpha: 1)
        
        // input container
        let inputHStack = UIStackView()
        inputHStack.axis = .horizontal
        inputHStack.spacing = 8
        inputHStack.alignment = .center
        
        if let prefixText = prefix {
            prefixLabel.text = prefixText
            prefixLabel.font = .boldSystemFont(ofSize: 17)
            prefixLabel.textColor = .systemGray
            prefixLabel.setContentHuggingPriority(.required, for: .horizontal)
            inputHStack.addArrangedSubview(prefixLabel)
        }
        
        // textfield
        textField.borderStyle = .roundedRect
        textField.keyboardType = keyboardType
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.autocapitalizationType = .none
        textField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        inputHStack.addArrangedSubview(textField)
        
        // error container
        errorLabel.font = .systemFont(ofSize: 12)
        errorLabel.textColor = .systemRed
        errorLabel.numberOfLines = 2
        errorLabel.alpha = 0
        
        let dummyErrorLabel = UILabel()
        dummyErrorLabel.font = errorLabel.font
        dummyErrorLabel.numberOfLines = 2
        dummyErrorLabel.text = "X\nX"
        dummyErrorLabel.isHidden = true
        
        let errorContainer = UIView()
        errorContainer.addSubview(dummyErrorLabel)
        errorContainer.addSubview(errorLabel)
        dummyErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // root container
        let rootStack = UIStackView(arrangedSubviews: [titleLabel, inputHStack, errorContainer])
        rootStack.axis = .vertical
        rootStack.spacing = 5
        rootStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rootStack)
        
        NSLayoutConstraint.activate([
            dummyErrorLabel.topAnchor.constraint(equalTo: errorContainer.topAnchor),
            dummyErrorLabel.bottomAnchor.constraint(equalTo: errorContainer.bottomAnchor),
            dummyErrorLabel.leadingAnchor.constraint(equalTo: errorContainer.leadingAnchor),
            dummyErrorLabel.trailingAnchor.constraint(equalTo: errorContainer.trailingAnchor),
            
            errorLabel.topAnchor.constraint(equalTo: errorContainer.topAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: errorContainer.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: errorContainer.trailingAnchor),
            
            rootStack.topAnchor.constraint(equalTo: topAnchor),
            rootStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            rootStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            rootStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    // MARK: STATE MANAGEMENT
    private func setupActions() {
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        textField.addTarget(self, action: #selector(focusStateChanged), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(focusStateChanged), for: .editingDidEnd)
    }
    
    @objc private func textChanged() {
        hasInteracted = true
        updatePrefixColor()
        onTextChange?(textField.text ?? "")
    }
    
    @objc private func focusStateChanged() {
        updatePrefixColor()
    }
    
    private func updatePrefixColor() {
        let isFocused = textField.isFirstResponder
        let hasText = !(textField.text?.isEmpty ?? true)
        prefixLabel.textColor = (isFocused || hasText) ? .black : .systemGray
    }
    
    func resetInteraction() {
        hasInteracted = false
    }
    
    func updateError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = message.isEmpty ? 0 : 1
    }
    
    // MARK: BOILERPLATE
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
