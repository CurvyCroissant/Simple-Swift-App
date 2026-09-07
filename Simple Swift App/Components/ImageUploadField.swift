//  Components/ImageUploadField.swift

import UIKit

class ImageUploadField: UIView {
    let titleLabel = UILabel()
    let infoLabel = UILabel()
    let imageButton = UIButton(type: .system)
    
    private(set) var hasError = false
    var onTap: (() -> Void)?
    
    init(title: String, infoText: String) {
        super.init(frame: .zero)
        
        setupLayout(title: title, infoText: infoText)
        imageButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        setEmptyState()
    }
    
    private func setupLayout(title: String, infoText: String) {
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 17, weight: .heavy)
        titleLabel.textColor = UIColor(red: 0.09, green: 0.36, blue: 0.62, alpha: 1)
        
        infoLabel.text = infoText
        infoLabel.font = .systemFont(ofSize: 12)
        infoLabel.textColor = .systemGray
        infoLabel.numberOfLines = 0
        
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        imageButton.heightAnchor.constraint(equalToConstant: 150).isActive = true
        imageButton.layer.cornerRadius = 8
        imageButton.clipsToBounds = true
        imageButton.backgroundColor = .clear
        imageButton.tintColor = .black
        
        let rootStack = UIStackView(arrangedSubviews: [titleLabel, infoLabel, imageButton])
        rootStack.axis = .vertical
        rootStack.spacing = 8
        rootStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rootStack)
        
        NSLayoutConstraint.activate([
            rootStack.topAnchor.constraint(equalTo: topAnchor),
            rootStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            rootStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            rootStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    @objc private func tapped() {
        onTap?()
    }
    
    func setEmptyState() {
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
        imageButton.setImage(UIImage(systemName: "camera", withConfiguration: config), for: .normal)
        imageButton.imageView?.contentMode = .center
        imageButton.contentHorizontalAlignment = .center
        imageButton.contentVerticalAlignment = .center
    }
    
    func setFilledState(image: UIImage) {
        imageButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        imageButton.contentHorizontalAlignment = .fill
        imageButton.contentVerticalAlignment = .fill
        imageButton.imageView?.contentMode = .scaleAspectFill
    }
    
    func setInfo(_ text: String, isError: Bool) {
        infoLabel.text = text
        infoLabel.textColor = isError ? .systemRed : .systemGray
        hasError = isError
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemeted")
    }
}
