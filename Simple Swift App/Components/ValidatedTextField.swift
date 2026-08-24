//
//  ValidatedTextField.swift
//  Simple Swift App
//
//  Created by ITBCA on 24/08/26.
//

import SwiftUI

struct ValidatedTextField: View {
    
    // constant cuz they're only read to setup UI
    let title: String
    let errorMessage: String
    
    // binding cuz component needs to write data back to parent
    @Binding var text: String
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 5) {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("", text: $text)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .listRowSeparator(.hidden)
        .padding(.bottom, 10)
    }
}
