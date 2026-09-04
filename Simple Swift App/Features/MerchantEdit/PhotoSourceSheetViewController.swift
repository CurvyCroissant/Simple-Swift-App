//  Features/MerchantEdit/PhotoSourceSheetViewController.swift=

import UIKit

class PhotoSourceSheetViewController: UIViewController {
    var onSelectCamera: (() -> Void)?
    var onSelectGallery: (() -> Void)?
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 26.0, *) {
            view.backgroundColor = .clear
            
            let visualEffectView = UIVisualEffectView()
            visualEffectView.effect = UIGlassEffect()
            visualEffectView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(visualEffectView)
            
            NSLayoutConstraint.activate([
                visualEffectView.topAnchor.constraint(equalTo: view.topAnchor),
                visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        } else {
            view.backgroundColor = .systemBackground
        }
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        let camBtn = createButton(title: "Kamera", icon: "camera", action: #selector(camTapped))
        let galBtn = createButton(title: "Galeri", icon: "photo", action: #selector(galTapped))
        
        stack.addArrangedSubview(camBtn)
        stack.addArrangedSubview(galBtn)
        stack.addArrangedSubview(UIView())
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 35),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - COMPONENTS
    private func createButton(title: String, icon: String, action: Selector) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: icon)
        config.title = title
        config.imagePadding = 10
        config.baseForegroundColor = .label
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0)
        
        let btn = UIButton(configuration: config)
        btn.backgroundColor = .secondarySystemGroupedBackground
        btn.layer.cornerRadius = 10
        btn.tintColor = .label
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: action, for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            btn.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        return btn
    }
    
    // MARK: - ACTIONS
    @objc private func camTapped() {
        dismiss(animated: true) { [weak self] in
            self?.onSelectCamera?()
        }
    }
    
    @objc private func galTapped() {
        dismiss(animated: true) { [weak self] in
            self?.onSelectGallery?()
        }
    }
}
