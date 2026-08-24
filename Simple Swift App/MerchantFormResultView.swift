import SwiftUI

struct MerchantFormResultView: View {
    let ktp: String
    let npwp: String
    let kodePos: String
    let namaUsaha: String
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            Text("KTP: \n\(ktp)")
            Text("NPWP: \n\(npwp)")
            Text("Kode Pos: \n\(kodePos)")
            Text("Nama Usaha: \n\(namaUsaha)")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
    }
}

