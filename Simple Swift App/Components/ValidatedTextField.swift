import SwiftUI

struct ValidatedTextField: View {
    let title: String
    let errorMessage: String
    
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
