//  Components/PrimaryButton.swift

import UIKit

class PrimaryButton: UIButton {
    init(title: String = "") {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        backgroundColor = UIColor(red: 0.09, green: 0.36, blue: 0.62, alpha: 1.0)
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
