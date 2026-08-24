//
//  UIKitMerchantFormViewController.swift
//  Simple Swift App
//
//  Created by ITBCA on 20/08/26.
//

// Dictates which view orchestrates the logic for this specific screen

import UIKit

// instantiates an empty, generic UIView as its root view
class UIKitMerchantFormViewController: UIViewController {
    private let maxLengthKtp = 16
    private let maxLengthNpwp = 16
    private let maxLengthKodePos = 5
    private let maxLengthNamaUsaha = 23
    
    private func isFieldValid(text: String, maxLength: Int) -> Bool {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedText.isEmpty && trimmedText.count <= maxLength
    }
    
    private var isFormValid: Bool {
        let ktpIsValid = isFieldValid(text: formView.ktpTextField.text ?? "", maxLength: maxLengthKtp)
        let npwpIsValid = isFieldValid(text: formView.npwpTextField.text ?? "", maxLength: maxLengthNpwp)
        let kodePosIsValid = isFieldValid(text: formView.kodePosTextField.text ?? "", maxLength: maxLengthKodePos)
        let namaUsahaIsValid = isFieldValid(text: formView.namaUsahaTextField.text ?? "", maxLength: maxLengthNamaUsaha)
        
        return ktpIsValid && npwpIsValid && kodePosIsValid && namaUsahaIsValid
    }
    
    private var formView: UIKitMerchantFormView {
        return view as! UIKitMerchantFormView
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let currentText = textField.text ?? ""
        
        switch textField {
        case formView.ktpTextField:
            formView.ktpErrorLabel.isHidden = isFieldValid(text: currentText, maxLength: maxLengthKtp)
        case formView.npwpTextField:
            formView.npwpErrorLabel.isHidden = isFieldValid(text: currentText, maxLength: maxLengthNpwp)
        case formView.kodePosTextField:
            formView.kodePosErrorLabel.isHidden = isFieldValid(text: currentText, maxLength: maxLengthKodePos)
        case formView.namaUsahaTextField:
            formView.namaUsahaErrorLabel.isHidden = isFieldValid(text: currentText, maxLength: maxLengthNamaUsaha)
        default:
            break
        }
        
        formView.submitButton.isEnabled = isFormValid
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formView.ktpTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        formView.npwpTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        formView.kodePosTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        formView.namaUsahaTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        formView.submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    @objc private func submitButtonTapped() {
        let ktp = formView.ktpTextField.text ?? ""
        let npwp = formView.npwpTextField.text ?? ""
        let kodePos = formView.kodePosTextField.text ?? ""
        let namaUsaha = formView.namaUsahaTextField.text ?? ""
        
        let resultViewController = UIKitMerchantFormResultViewController(ktp: ktp, npwp: npwp, kodePos: kodePos, namaUsaha: namaUsaha)
        navigationController?.pushViewController(resultViewController, animated: true)
    }
    
    override func loadView() { // overrides this lifecycle method with the custom view
        view = UIKitMerchantFormView()
    }
}
