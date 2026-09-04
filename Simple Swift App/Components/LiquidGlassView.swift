//  Components/LiquidGlassView.swift

import UIKit

class LiquidGlassView: UIVisualEffectView {
    // MARK: CUSTOM
    init() {
        super.init(effect: nil)
        
        if #available(iOS 26.0, *) {
            self.effect = UIGlassEffect()
        } else {
            self.effect = UIBlurEffect(style: .systemMaterial)
        }
    }
    
    // MARK: BOILERPLATE
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
