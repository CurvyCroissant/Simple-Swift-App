// Components/ValidatedTextField.swift

import SwiftUI

struct ValidatedTextField: View {
    let title: String
    let errorMessage: String
    
    @Binding var text: String
    
    var prefix: String? = nil
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.body)
                .fontWeight(.heavy)
                .foregroundColor(Color(red: 0.09, green: 0.36, blue: 0.62))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 8) {
                // Render prefix if given
                if let prefix = prefix {
                    Text(prefix)
                        .bold()
                        .foregroundColor(isFocused || !text.isEmpty ? .black : .gray)
                }
                
                TextField("", text: $text)
                    .focused($isFocused)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
            
            Text(errorMessage.isEmpty ? " \n " : errorMessage)
                .foregroundColor(.red)
                .font(.caption)
                .lineLimit(2, reservesSpace: true)
                .opacity(errorMessage.isEmpty ? 0 : 1)
        }
        .listRowSeparator(.hidden)
        .padding(.bottom, 10)
    }
}
