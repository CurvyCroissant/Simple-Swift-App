//  Components/SourceOptionButton.swift

import UIKit

class SourceOptionButton: UIButton {
    init(icon: String, title: String) {
        super.init(frame: .zero)
        
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: icon)
        config.title = title
        config.imagePadding = 12
        config.baseForegroundColor = .black
        config.background.backgroundColor = UIColor(white: 0.95, alpha: 1)
        config.background.cornerRadius = 10
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16)
        configuration = config
        contentHorizontalAlignment = .leading
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
