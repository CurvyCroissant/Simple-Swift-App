// Views/MerchantFormResultView.swift

import SwiftUI

struct MerchantFormResultView: View {
    let merchant: MerchantModel
    
    @EnvironmentObject private var navigator: AppNavigator
    @EnvironmentObject private var repository: MerchantRepository
    
    private func formatDisplayKTP(_ text: String) -> String {
        var formatted = ""
        for (index, char) in text.enumerated() {
            if index != 0 && index % 4 == 0 {
                formatted.append(" ")
            }
            formatted.append(char)
        }
        return formatted
    }
    
    private func formatRupiahDisplay(_ text: String) -> String {
        guard let number = Int64(text) else {
            return text
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: number)) ?? text
    }
    
    private func formatTanggal(_ date: Date?) -> String {
        guard let date = date else {
            return "-"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    // Final validation
    private var isDataValid: Bool {
        let isKtpValid = merchant.ktp.count == 16
        let isNpwpValid = !merchant.npwp.isEmpty && merchant.npwp.count <= 16
        let isRekeningValid = !merchant.nomorRekening.isEmpty && merchant.nomorRekening.count <= 16
        let isNamaUsahaValid = merchant.namaUsaha.isEmpty || (merchant.namaUsaha.count <= 23 && !merchant.namaUsaha.hasPrefix(" ") && !merchant.namaUsaha.hasSuffix(" "))
        let isFotoValid = merchant.foto != nil
        let isNamaValid = !merchant.nama.isEmpty && merchant.nama.count <= 100 && !merchant.nama.hasPrefix(" ") && !merchant.nama.hasSuffix(" ")
        let isNomorHpValid = merchant.nomorHp.isEmpty || (merchant.nomorHp.count >= 10 && merchant.nomorHp.count <= 13)
        let isNominalValid = !merchant.nominal.isEmpty && merchant.nominal.count <= 16
        
        return isKtpValid && isNpwpValid && isRekeningValid && isNamaUsahaValid && isFotoValid && isNamaValid && isNomorHpValid && isNominalValid
    }
    
    // Repopulate drafts and routes to target edit page
    private func triggerEdit(field: EditField, route: Route) {
        repository.draftKtp = formatDisplayKTP(merchant.ktp)
        repository.draftNpwp = merchant.npwp
        repository.draftNomorRekening = merchant.nomorRekening
        repository.draftNamaUsaha = merchant.namaUsaha
        repository.draftPhoto = merchant.foto
        repository.draftNama = merchant.nama
        repository.draftNomorHp = merchant.nomorHp
        repository.draftNominal = formatRupiahDisplay(merchant.nominal)
        repository.draftTanggal = formatTanggal(merchant.tanggal)
        
        repository.activeEditField = field
        navigator.path = [.result(merchant: merchant), route]
    }
    
    // UI Builder for editable text rows
    private func editRow(title: String, value: String, field: EditField, route: Route) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 12) {
                Text(title)
                    .fontWeight(.heavy)
                    .foregroundColor(Color(red: 0.09, green: 0.36, blue: 0.62))
                
                Button { triggerEdit(field: field, route: route) } label: {
                    Image(systemName: "pencil")
                        .font(.caption2.weight(.heavy))
                        .foregroundColor(Color(red: 0.09, green: 0.36, blue: 0.62))
                        .padding(6)
                        .background(Circle().fill(Color.white))
                }
            }
            Text(value)
                .font(.title3)
        }
    }
    
    var body: some View {
        BaseFormLayout(title: "Profil Pengguna") {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 26) {
                    editRow(title: "No KTP", value: formatDisplayKTP(merchant.ktp), field: .ktp, route: .editForm(merchant: merchant))
                    editRow(title: "Nama", value: merchant.nama, field: .nama, route: .details(merchant: merchant))
                    editRow(title: "NPWP", value: merchant.npwp, field: .npwp, route: .editForm(merchant: merchant))
                    editRow(title: "No Rekening", value: merchant.nomorRekening, field: .nomorRekening, route: .editForm(merchant: merchant))
                    editRow(title: "No HP", value: merchant.nomorHp.isEmpty ? "-" : merchant.nomorHp, field: .nomorHp, route: .details(merchant: merchant))
                    editRow(title: "Tanggal", value: formatTanggal(merchant.tanggal), field: .tanggal, route: .details(merchant: merchant))
                    editRow(title: "Nominal", value: "Rp \(formatRupiahDisplay(merchant.nominal))", field: .nominal, route: .details(merchant: merchant))
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Foto")
                            .fontWeight(.heavy)
                            .foregroundColor(Color(red: 0.09, green: 0.36, blue: 0.62))
                        
                        if let fotoData = merchant.foto, let uiImage = UIImage(data: fotoData) {
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 150)
                                    .clipped()
                                    .cornerRadius(10)
                                
                                Button {
                                    triggerEdit(field: .foto, route: .photoUpload(merchant: merchant))
                                } label: {
                                    Text("Edit")
                                        .font(.caption)
                                        .bold()
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(Color.white)
                                        .foregroundColor(Color(red: 0.09, green: 0.36, blue: 0.62))
                                        .cornerRadius(6)
                                }
                                .padding(5)
                            }
                        } else {
                            Text("-")
                                .font(.title3)
                        }
                    }
                    editRow(title: "Nama Usaha di Stiker QRIS", value: merchant.namaUsaha.isEmpty ? "-" : merchant.namaUsaha, field: .namaUsaha, route: .editForm(merchant: merchant))  
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.regularMaterial)
                .cornerRadius(15)
                .padding()
            }
        } bottomButton: {
            Button {
                if isDataValid {
                    repository.reset()
                    navigator.popToRoot()
                }
            } label: {
                Text("Lanjut")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .background(Color(red: 0.09, green: 0.36, blue: 0.62))
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.bottom, 10)
            .disabled(!isDataValid)
            .opacity(isDataValid ? 1.0 : 0.5)
        }
        .navigationBarBackButtonHidden(true)
    }
}
