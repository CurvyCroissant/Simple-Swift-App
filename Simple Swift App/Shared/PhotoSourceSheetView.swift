//  Shared/PhotoSourceSheetView.swift

import UIKit

class PhotoSourceSheetView: UIView {
    let cameraButton = SourceOptionButton(icon: "camera", title: "Kamera")
    let galleryButton = SourceOptionButton(icon: "photo", title: "Galeri")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    private func setupLayout() {
        let stack = UIStackView(arrangedSubviews: [cameraButton, galleryButton])
        stack.axis = .vertical
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 35),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
