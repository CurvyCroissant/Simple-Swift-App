import SwiftUI

struct MerchantFormResultView: View {
    let ktp: String
    let npwp: String
    let nomorRekening: String
    let namaUsaha: String
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            Text("KTP: \n\(ktp)")
            Text("NPWP: \n\(npwp)")
            Text("Nomor Rekening: \n\(nomorRekening)")
            Text("Nama Usaha: \n\(namaUsaha)")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
    }
}

