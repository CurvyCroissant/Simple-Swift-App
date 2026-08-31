// Core/ValidatedField.swift

import Foundation

struct ValidatedField {
    var text: String = "" {
        didSet {
            if text != oldValue {
                hasInteracted = true
            }
        }
    }
    var hasInteracted: Bool = false
}
