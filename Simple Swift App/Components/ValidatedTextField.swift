import SwiftUI

struct ValidatedTextField: View {
    let title: String
    let errorMessage: String
    
    @Binding var text: String
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("", text: $text)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            
            Text(errorMessage.isEmpty ? " " : errorMessage)
                .foregroundColor(.red)
                .font(.caption)
                .opacity(errorMessage.isEmpty ? 0 : 1)
        }
        .listRowSeparator(.hidden)
        .padding(.bottom, 10)
    }
}
