// Views/MerchantFormResultView.swift

import SwiftUI

struct MerchantFormResultView: View {
    let merchant: MerchantModel 
    
    private func formatDisplayKTP(_ text: String) -> String {
        var formatted = ""
        for (index, char) in text.enumerated() {
            if index != 0 && index % 4 == 0 { formatted.append(" ") }
            formatted.append(char)
        }
        return formatted
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Color(red: 0.09, green: 0.36, blue: 0.62)
                    .frame(height: 350)
                    .ignoresSafeArea(edges: .top)
                Color.white
                    .ignoresSafeArea(edges: .bottom)
            }
            
            LazyVStack(alignment: .leading, spacing: 20) {
                Text("KTP: \n\(formatDisplayKTP(merchant.ktp))")
                Text("NPWP: \n\(merchant.npwp)")
                Text("Nomor Rekening: \n\(merchant.nomorRekening)")
                Text("Nama Usaha: \n\(merchant.namaUsaha)")
                
                Text("Foto:")
                if let fotoData = merchant.foto, let uiImage = UIImage(data: fotoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .cornerRadius(10)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.regularMaterial) 
            .cornerRadius(15)
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}
