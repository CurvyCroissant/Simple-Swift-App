//  Components/EditRowView.swift

import UIKit

class EditRowView: UIView {
    private let titleLabel = UILabel()
    private let editButton = UIButton(type: .system)
    private let valueLabel = UILabel()
    
    var onEditTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        editButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        titleLabel.font = .systemFont(ofSize: 17, weight: .heavy)
        titleLabel.textColor = UIColor(red: 0.09, green: 0.36, blue: 0.62, alpha: 1)
        
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "pencil", withConfiguration: UIImage.SymbolConfiguration(pointSize: 10, weight: .heavy))
        config.baseBackgroundColor = .white
        config.baseForegroundColor = UIColor(red: 0.09, green: 0.36, blue: 0.62, alpha: 1)
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6)
        editButton.configuration = config
        
        let headerStack = UIStackView(arrangedSubviews: [titleLabel, editButton])
        headerStack.axis = .horizontal
        headerStack.spacing = 12
        headerStack.alignment = .center
        
        valueLabel.font = .systemFont(ofSize: 20)
        valueLabel.numberOfLines = 0
        
        let rootStack = UIStackView(arrangedSubviews: [headerStack, valueLabel])
        rootStack.axis = .vertical
        rootStack.spacing = 5
        rootStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rootStack)
        
        NSLayoutConstraint.activate([
            rootStack.topAnchor.constraint(equalTo: topAnchor),
            rootStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            rootStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            rootStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    @objc private func tapped() { onEditTap?() }
    
    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
