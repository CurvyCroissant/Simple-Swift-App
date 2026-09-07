//  Components/BaseFormView.swift

import UIKit

class BaseFormView: UIView {
    let scrollView = UIScrollView()
    let contentView = UIView()
    let formCard = FormCardView()
    let submitButton = PrimaryButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGroupedBackground
        setupLayout()
    }
    
    private func setupLayout() {
        let blueBackground = UIView()
        blueBackground.backgroundColor = UIColor(red: 0.09, green: 0.36, blue: 0.62, alpha: 1)
        
        [blueBackground, scrollView, submitButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        scrollView.alwaysBounceVertical = true
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        formCard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(formCard)
        
        NSLayoutConstraint.activate([
            blueBackground.topAnchor.constraint(equalTo: topAnchor),
            blueBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            blueBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
            blueBackground.heightAnchor.constraint(equalToConstant: 350),

            submitButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            submitButton.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -10),
            submitButton.heightAnchor.constraint(equalToConstant: 50),

            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -10),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),

            formCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            formCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            formCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            formCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
