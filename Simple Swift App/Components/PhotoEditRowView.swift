//  Components/PhotoEditRowView.swift

import UIKit

class PhotoEditRowView: UIView {
    private let titleLabel = UILabel()
    private let imageContainer = UIView()
    private let imageView = UIImageView()
    private let editButton = UIButton(type: .system)
    private let placeholderLabel = UILabel()
    
    var onEditTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        editButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        titleLabel.font = .systemFont(ofSize: 17, weight: .heavy)
        titleLabel.textColor = UIColor(red: 0.09, green: 0.36, blue: 0.62, alpha: 1)
        
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imageContainer.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        var config = UIButton.Configuration.filled()
        config.title = "Edit"
        config.baseBackgroundColor = .white
        config.baseForegroundColor = UIColor(red: 0.09, green: 0.36, blue: 0.62, alpha: 1)
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        editButton.configuration = config
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
        imageContainer.addSubview(imageView)
        imageContainer.addSubview(editButton)
        
        placeholderLabel.text = "-"
        placeholderLabel.font = .systemFont(ofSize: 20)
        
        let rootStack = UIStackView(arrangedSubviews: [titleLabel, imageContainer, placeholderLabel])
        rootStack.axis = .vertical
        rootStack.spacing = 5
        rootStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rootStack)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: imageContainer.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor),
            
            editButton.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: 5),
            editButton.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor, constant: -5),
            
            rootStack.topAnchor.constraint(equalTo: topAnchor),
            rootStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            rootStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            rootStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    @objc private func tapped() {
        onEditTap?()
    }
    
    func configure(title: String, image: UIImage?) {
        titleLabel.text = title
        
        if let image = image {
            imageView.image = image
            imageContainer.isHidden = false
            placeholderLabel.isHidden = true
        } else {
            imageContainer.isHidden = true
            placeholderLabel.isHidden = false
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
