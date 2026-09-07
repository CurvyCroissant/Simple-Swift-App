//  Components/FormCardView.swift

import UIKit

class FormCardView: UIView {
    private let glassCard = LiquidGlassView()
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false

        glassCard.translatesAutoresizingMaskIntoConstraints = false
        glassCard.clipsToBounds = true
        glassCard.layer.borderWidth = 1
        glassCard.layer.borderColor = UIColor.white.withAlphaComponent(0.6).cgColor

        if #available(iOS 26.0, *) {
            glassCard.cornerConfiguration = .uniformCorners(radius: .fixed(15))
        } else {
            glassCard.layer.cornerRadius = 15
        }

        addSubview(glassCard)

        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        glassCard.contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            glassCard.topAnchor.constraint(equalTo: topAnchor),
            glassCard.leadingAnchor.constraint(equalTo: leadingAnchor),
            glassCard.trailingAnchor.constraint(equalTo: trailingAnchor),
            glassCard.bottomAnchor.constraint(equalTo: bottomAnchor),

            stackView.topAnchor.constraint(equalTo: glassCard.contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: glassCard.contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: glassCard.contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: glassCard.contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func addField(_ view: UIView) {
        stackView.addArrangedSubview(view)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
