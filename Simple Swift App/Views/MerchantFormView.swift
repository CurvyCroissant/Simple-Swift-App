// Views/MerchantFormView.swift

import SwiftUI

struct MerchantFormView: View {
    @StateObject private var viewModel = MerchantFormViewModel()
    @EnvironmentObject private var navigator: AppNavigator
    @EnvironmentObject private var repository: MerchantRepository

    var body: some View {
        NavigationStack(path: $navigator.path) {
            BaseFormLayout(title: "Registrasi Pengguna") {
                Form {
                    Section {
                        VStack(spacing: 0) {
                            ValidatedTextField(
                                title: "KTP",
                                errorMessage: viewModel.getKtpError(),
                                text: $viewModel.ktp.text
                            )
                            .onChange(of: viewModel.ktp.text) { newValue in
                                let formatted = viewModel.formatKTP(newValue)
                                if viewModel.ktp.text != formatted {
                                    viewModel.ktp.text = formatted
                                }
                            }
                            
                            ValidatedTextField(
                                title: "NPWP",
                                errorMessage: viewModel.getNpwpError(),
                                text: $viewModel.npwp.text
                            )
                            .onChange(of: viewModel.npwp.text) { newValue in
                                let digits = viewModel.rawDigits(newValue)
                                let limited = String(digits.prefix(viewModel.maxLengthNpwp))
                                if viewModel.npwp.text != limited {
                                    viewModel.npwp.text = limited
                                }
                            }
                            
                            ValidatedTextField(
                                title: "Nomor Rekening",
                                errorMessage: viewModel.getNomorRekeningError(),
                                text: $viewModel.nomorRekening.text
                            )
                            .onChange(of: viewModel.nomorRekening.text) { newValue in
                                let digits = viewModel.rawDigits(newValue)
                                let limited = String(digits.prefix(viewModel.maxLengthNomorRekening))
                                if viewModel.nomorRekening.text != limited {
                                    viewModel.nomorRekening.text = limited
                                }
                            }
                            
                            ValidatedTextField(
                                title: "Nama Usaha di Stiker QRIS",
                                errorMessage: viewModel.getNamaUsahaError(),
                                text: $viewModel.namaUsaha.text
                            )
                            .onChange(of: viewModel.namaUsaha.text) { newValue in
                                if newValue.count > viewModel.maxLengthNamaUsaha {
                                    viewModel.namaUsaha.text = String(newValue.prefix(viewModel.maxLengthNamaUsaha))
                                }
                            }
                        }
                    }
                    .listRowBackground(
                        Rectangle()
                            .fill(.regularMaterial)
                            .overlay(
                                Rectangle()
                                    .stroke(.white.opacity(0.6), lineWidth: 1)
                            )
                    )
                }
                .scrollContentBackground(.hidden)
            }
            bottomButton: {
                    Button {
                        if viewModel.canSubmit {
                            // Package data into model
                            let newMerchant = MerchantModel(
                                ktp: viewModel.rawDigits(viewModel.ktp.text),
                                npwp: viewModel.npwp.text,
                                nomorRekening: viewModel.nomorRekening.text,
                                namaUsaha: viewModel.namaUsaha.text
                            )
                            // Navigate with model
                            navigator.navigate(to: .photoUpload(merchant: newMerchant))
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
                    .disabled(!viewModel.canSubmit)
                    .opacity(viewModel.canSubmit ? 1.0 : 0.5)
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case let .result(merchant):
                    MerchantFormResultView(merchant: merchant)
                case let .photoUpload(merchant: merchant):
                    MerchantPhotoView(merchant: merchant)
                }
            }
        }
    }
}
