//  Features/MerchantDetails/MerchantDetailsView.swift

import SwiftUI

struct MerchantDetailsView: View {
    @StateObject private var viewModel = MerchantDetailsViewModel()
    @EnvironmentObject private var navigator: AppNavigator
    @EnvironmentObject private var repository: MerchantRepository
    
    let merchant: MerchantModel
    
    var body: some View {
        BaseFormLayout(title: "Registrasi 3/3") {
            Form {
                Section {
                    VStack(spacing: 0) {
                        ValidatedTextField(
                            title: "Nama",
                            errorMessage: viewModel.getNamaError(),
                            text: $viewModel.nama.text
                        )
                        .onChange(of: viewModel.nama.text) { newValue in
                            let formatted = viewModel.formatAlphanumeric(newValue)
                            if viewModel.nama.text != formatted {
                                viewModel.nama.text = formatted
                            }
                            repository.draftNama = formatted
                        }
                        
                        ValidatedTextField(
                            title: "No HP",
                            errorMessage: viewModel.getNomorHpError(),
                            text: $viewModel.nomorHp.text
                        )
                        .onChange(of: viewModel.nomorHp.text) { newValue in
                            let digits = String(viewModel.rawDigits(newValue).prefix(13))
                            if viewModel.nomorHp.text != digits {
                                viewModel.nomorHp.text = digits
                            }
                            repository.draftNomorHp = digits
                        }
                        
                        ValidatedTextField(
                            title: "Nominal",
                            errorMessage: viewModel.getNominalError(),
                            text: $viewModel.nominal.text,
                            prefix: "Rp"
                        )
                        .onChange(of: viewModel.nominal.text) { newValue in
                            let formatted = viewModel.formatRupiah(newValue)
                            if viewModel.nominal.text != formatted {
                                viewModel.nominal.text = formatted
                            }
                            repository.draftNominal = formatted
                        }
                        
                        ValidatedTextField(
                            title: "Tanggal",
                            errorMessage: viewModel.getTanggalError(),
                            text: $viewModel.tanggal.text
                        )
                        .onChange(of: viewModel.tanggal.text) { newValue in
                            let formatted = viewModel.formatTanggalInput(newValue)
                            if viewModel.tanggal.text != formatted {
                                viewModel.tanggal.text = formatted
                            }
                            repository.draftTanggal = formatted
                        }
                    }
                }
                .listRowBackground(
                    Rectangle()
                        .fill(.regularMaterial)
                        .overlay(Rectangle().stroke(.white.opacity(0.6), lineWidth: 1))
                )
            }
            .scrollContentBackground(.hidden)
            .onAppear {
                if viewModel.nama.text.isEmpty || repository.activeEditField != .none {
                    viewModel.nama.text = repository.draftNama
                    viewModel.nomorHp.text = repository.draftNomorHp
                    viewModel.nominal.text = repository.draftNominal
                    viewModel.tanggal.text = repository.draftTanggal
                }
            }
        } bottomButton: {
            Button {
                if viewModel.canSubmit {
                    var finalMerchant = merchant
                    finalMerchant.nama = viewModel.nama.text
                    finalMerchant.nomorHp = viewModel.rawDigits(viewModel.nomorHp.text)
                    finalMerchant.nominal = viewModel.rawDigits(viewModel.nominal.text)
                    finalMerchant.tanggal = viewModel.parseTanggal(viewModel.tanggal.text)
                    repository.save(merchant: finalMerchant)
                    navigator.navigate(to: .result(merchant: finalMerchant))
                }            } label: {
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
            .disabled(!viewModel.canSubmit)
            .opacity(viewModel.canSubmit ? 1.0 : 0.5)
        }
    }
}
