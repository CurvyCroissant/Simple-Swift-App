// Features/MerchantForm/MerchantFormView.swift

import SwiftUI

struct MerchantFormView: View {
    @StateObject private var viewModel = MerchantFormViewModel()
    @EnvironmentObject private var navigator: AppNavigator
    @EnvironmentObject private var repository: MerchantRepository

    var body: some View {
        BaseFormLayout(title: "Registrasi 1/3") {
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
                            repository.draftKtp = formatted
                        }
                        .opacity(repository.activeEditField == .none || repository.activeEditField == .ktp ? 1.0 : 0.0)
                        .disabled(repository.activeEditField != .none && repository.activeEditField != .ktp)
                        
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
                            repository.draftNpwp = limited
                        }
                        .opacity(repository.activeEditField == .none || repository.activeEditField == .npwp ? 1.0 : 0.0)
                        .disabled(repository.activeEditField != .none && repository.activeEditField != .npwp)
                        
                        ValidatedTextField(
                            title: "Nomor Rekening",
                            errorMessage: viewModel.getNomorRekeningError(),
                            text: $viewModel.nomorRekening.text
                        )
                        .onChange(of: viewModel.nomorRekening.text) { newValue in
                            let digits = viewModel.rawDigits(newValue)
                            let limited = String(digits.prefix(viewModel.maxLengthNomorRekening))
                            if viewModel.nomorRekening.text != limited { viewModel.nomorRekening.text = limited
                            }
                            repository.draftNomorRekening = limited
                        }
                        .opacity(repository.activeEditField == .none || repository.activeEditField == .nomorRekening ? 1.0 : 0.0)
                        .disabled(repository.activeEditField != .none && repository.activeEditField != .nomorRekening)
                        
                        ValidatedTextField(
                            title: "Nama Usaha di Stiker QRIS",
                            errorMessage: viewModel.getNamaUsahaError(),
                            text: $viewModel.namaUsaha.text
                        )
                        .onChange(of: viewModel.namaUsaha.text) { newValue in
                            var finalValue = newValue
                            if newValue.count > viewModel.maxLengthNamaUsaha {
                                finalValue = String(newValue.prefix(viewModel.maxLengthNamaUsaha))
                                viewModel.namaUsaha.text = finalValue
                            }
                            repository.draftNamaUsaha = finalValue
                        }
                        .opacity(repository.activeEditField == .none || repository.activeEditField == .namaUsaha ? 1.0 : 0.0)
                        .disabled(repository.activeEditField != .none && repository.activeEditField != .namaUsaha)
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
            .onAppear {
                let isDraftEmpty = repository.draftKtp.isEmpty && repository.draftNpwp.isEmpty && repository.draftNomorRekening.isEmpty && repository.draftNamaUsaha.isEmpty
                
                if isDraftEmpty && repository.activeEditField == .none {
                    viewModel.reset()
                } else if viewModel.ktp.text.isEmpty || repository.activeEditField != .none {
                    viewModel.ktp.text = repository.draftKtp
                    viewModel.npwp.text = repository.draftNpwp
                    viewModel.nomorRekening.text = repository.draftNomorRekening
                    viewModel.namaUsaha.text = repository.draftNamaUsaha
                }
            }
        }
        bottomButton: {
                Button {
                    if viewModel.canSubmit {
                        let newMerchant = MerchantModel(
                            ktp: viewModel.rawDigits(viewModel.ktp.text),
                            npwp: viewModel.npwp.text,
                            nomorRekening: viewModel.nomorRekening.text,
                            namaUsaha: viewModel.namaUsaha.text,
                            foto: repository.draftPhoto,
                            nama: repository.draftNama,
                            nomorHp: repository.draftNomorHp,
                            nominal: repository.draftNominal.filter { $0.isNumber },
                            tanggal: {
                                let df = DateFormatter()
                                df.dateFormat = "yyyy-MM-dd"
                                return df.date(from: repository.draftTanggal)
                            }()
                        )
                        
                        if repository.activeEditField != .none {
                                navigator.path = [.result(merchant: newMerchant)] 
                            } else {
                                navigator.navigate(to: .photoUpload(merchant: newMerchant))
                            }
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
    }
}
