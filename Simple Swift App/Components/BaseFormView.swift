//  Components/BaseFormView.swift

import UIKit

class BaseFormView: UIView {
    let scrollView = UIScrollView()
    let contentView = UIView()
    let glassCard = LiquidGlassView()
    let stackView = UIStackView()
    let submitButton = UIButton(type: .system)
    
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
        
        glassCard.translatesAutoresizingMaskIntoConstraints = false
        glassCard.clipsToBounds = true
        glassCard.layer.borderWidth = 1
        glassCard.layer.borderColor = UIColor.white.withAlphaComponent(0.6).cgColor
        
        if #available(iOS 26.0, *) {
            glassCard.cornerConfiguration = .uniformCorners(radius: .fixed(15))
        } else {
            glassCard.layer.cornerRadius = 15
        }
        
        contentView.addSubview(glassCard)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 15
        glassCard.contentView.addSubview(stackView)
        
        submitButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        submitButton.backgroundColor = UIColor(red: 0.09, green: 0.36, blue: 0.62, alpha: 1)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 10
        
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

            glassCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            glassCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            glassCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            glassCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

            stackView.topAnchor.constraint(equalTo: glassCard.contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: glassCard.contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: glassCard.contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: glassCard.contentView.bottomAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
