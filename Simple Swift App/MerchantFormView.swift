//
//  MerchantFormView.swift
//  Simple Swift App
//
//  Created by ITBCA on 19/08/26.
//

import SwiftUI

struct MerchantFormView: View {
    
    // StateObject used in View to own an ObservableObject instance. View creates and holds object, making it persist as long as View exists.
    @StateObject private var viewModel = MerchantFormViewModel()
    
    // grab navigator from env
    @EnvironmentObject private var navigator: AppNavigator

    var body: some View {
        NavigationStack(path: $navigator.path) { // only in the root of the navigation flow
            Form {
                Section {
                    ValidatedTextField (
                        title: "KTP:",
                        errorMessage: viewModel.getErrorMessage(field: viewModel.ktp, text: "KTP", n: viewModel.maxLengthKtp, isValid: viewModel.isKtpValid),
                        text: $viewModel.ktp.text
                    )
                    ValidatedTextField (
                        title: "NPWP:",
                        errorMessage: viewModel.getErrorMessage(field: viewModel.npwp, text: "NPWP", n: viewModel.maxLengthNpwp, isValid: viewModel.isNpwpValid),
                        text: $viewModel.npwp.text
                    )
                    ValidatedTextField (
                        title: "Kode Pos:",
                        errorMessage: viewModel.getErrorMessage(field: viewModel.kodePos, text: "Kode Pos", n: viewModel.maxLengthKodePos, isValid: viewModel.isKodePosValid),
                        text: $viewModel.kodePos.text
                    )
                    ValidatedTextField (
                        title: "Nama Usaha:",
                        errorMessage: viewModel.getErrorMessage(field: viewModel.namaUsaha, text: "Nama Usaha", n: viewModel.maxLengthNamaUsaha, isValid: viewModel.isNamaUsahaValid),
                        text: $viewModel.namaUsaha.text
                    )
                }
                Section {
                    Button {
                        if viewModel.canSubmit {
                            
                            // ask navigator to handle routing
                            navigator.navigate(to: .result(
                                ktp: viewModel.ktp.text,
                                npwp: viewModel.npwp.text,
                                kodePos: viewModel.kodePos.text,
                                namaUsaha: viewModel.namaUsaha.text
                                )
                            )
                        }
                    } label: {
                        Text("Submit")
                            .bold()
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(!viewModel.canSubmit)
                }
            }
            
            // maps enum to actual view
            .navigationDestination(for: Route.self) { route in
                switch route {
                case let .result(ktp, npwp, kodePos, namaUsaha):
                    MerchantFormResultView(ktp: ktp, npwp: npwp, kodePos: kodePos, namaUsaha: namaUsaha)
                }
            }
        }
    }
}
