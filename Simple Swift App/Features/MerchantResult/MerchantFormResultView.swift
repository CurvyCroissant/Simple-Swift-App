// Features/MerchantResult/MerchantFormResultView.swift

import SwiftUI

struct MerchantFormResultView: View {
    let merchant: MerchantModel
    
    @EnvironmentObject private var navigator: AppNavigator
    @EnvironmentObject private var repository: MerchantRepository
    
    private var viewModel: MerchantFormResultViewModel {
            MerchantFormResultViewModel(merchant: merchant)
        }
    
    // Repopulate drafts and routes to target edit page
    private func triggerEdit(field: EditField, route: Route) {
        repository.draftKtp = viewModel.displayKTP
        repository.draftNpwp = merchant.npwp
        repository.draftNomorRekening = merchant.nomorRekening
        repository.draftNamaUsaha = viewModel.draftNamaUsaha
        repository.draftPhoto = merchant.foto
        repository.draftNama = merchant.nama
        repository.draftNomorHp = viewModel.draftNomorHp
        repository.draftNominal = viewModel.displayNominal
        repository.draftTanggal = viewModel.draftTanggal
        
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
                
                Button {
                    triggerEdit(field: field, route: route)
                } label: {
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
                                    editRow(title: "No KTP", value: viewModel.displayKTP, field: .ktp, route: .editForm(merchant: merchant))
                                    editRow(title: "Nama", value: merchant.nama, field: .nama, route: .details(merchant: merchant))
                                    editRow(title: "NPWP", value: merchant.npwp, field: .npwp, route: .editForm(merchant: merchant))
                                    editRow(title: "No Rekening", value: merchant.nomorRekening, field: .nomorRekening, route: .editForm(merchant: merchant))
                                    editRow(title: "No HP", value: viewModel.displayNomorHp, field: .nomorHp, route: .details(merchant: merchant))
                                    editRow(title: "Tanggal", value: viewModel.displayTanggal, field: .tanggal, route: .details(merchant: merchant))
                                    editRow(title: "Nominal", value: "Rp \(viewModel.displayNominal)", field: .nominal, route: .details(merchant: merchant))
                    
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
                    editRow(title: "Nama Usaha di Stiker QRIS", value: viewModel.displayNamaUsaha, field: .namaUsaha, route: .editForm(merchant: merchant))
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.regularMaterial)
                .cornerRadius(15)
                .padding()
            }
        } bottomButton: {
            Button {
                if viewModel.isDataValid {
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
            .disabled(!viewModel.isDataValid)
            .opacity(viewModel.isDataValid ? 1.0 : 0.5)
        }
        .navigationBarBackButtonHidden(true)
    }
}
