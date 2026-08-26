import SwiftUI

struct MerchantFormView: View {
    @StateObject private var viewModel = MerchantFormViewModel()
    @EnvironmentObject private var navigator: AppNavigator

    var body: some View {
        NavigationStack(path: $navigator.path) {
            ZStack {
                // ========== BACKGROUND LAYER ==========
                VStack(spacing: 0) {
                    Color(red: 0.09, green: 0.36, blue: 0.62)
                        .frame(height: 350)
                        .ignoresSafeArea(edges: .top)
                    Color.white
                        .ignoresSafeArea(edges: .bottom)
                }
                // ===================================
                
                // ========== FOREGROUND LAYER ==========
                VStack(spacing: 0) {
                    Text("Registrasi Pengguna")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.09, green: 0.36, blue: 0.62))
                    
                    Form {
                        Section {
                            VStack(spacing: 0) {
                                ValidatedTextField (
                                    title: "KTP",
                                    errorMessage: viewModel.getErrorMessage(field: viewModel.ktp, text: "KTP", n: viewModel.maxLengthKtp, isValid: viewModel.isKtpValid),
                                    text: $viewModel.ktp.text
                                )
                                ValidatedTextField (
                                    title: "NPWP",
                                    errorMessage: viewModel.getErrorMessage(field: viewModel.npwp, text: "NPWP", n: viewModel.maxLengthNpwp, isValid: viewModel.isNpwpValid),
                                    text: $viewModel.npwp.text
                                )
                                ValidatedTextField (
                                    title: "Nomor Rekening",
                                    errorMessage: viewModel.getErrorMessage(field: viewModel.nomorRekening, text: "Nomor Rekening", n: viewModel.maxLengthNomorRekening, isValid: viewModel.isNomorRekeningValid),
                                    text: $viewModel.nomorRekening.text
                                )
                                ValidatedTextField (
                                    title: "Nama Usaha di Stiker QRIS",
                                    errorMessage: viewModel.getErrorMessage(field: viewModel.namaUsaha, text: "Nama Usaha", n: viewModel.maxLengthNamaUsaha, isValid: viewModel.isNamaUsahaValid),
                                    text: $viewModel.namaUsaha.text
                                )
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
                    Button {
                        if viewModel.canSubmit {
                            navigator.navigate(to: .result(
                                ktp: viewModel.ktp.text,
                                npwp: viewModel.npwp.text,
                                nomorRekening: viewModel.nomorRekening.text,
                                namaUsaha: viewModel.namaUsaha.text)
                            )
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
                // ===================================
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case let .result(ktp, npwp, nomorRekening, namaUsaha):
                    MerchantFormResultView(ktp: ktp, npwp: npwp, nomorRekening: nomorRekening, namaUsaha: namaUsaha)
                }
            }
        }
    }
}
