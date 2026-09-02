// Features/MerchantEdit/MerchantEditView.swift

import SwiftUI

struct MerchantEditView: View {
    let merchant: MerchantModel
    @EnvironmentObject var repository: MerchantRepository
    
    var body: some View {
        MerchantEditUIKitWrapper(merchant: merchant)
            .ignoresSafeArea(edges: .top)
            .navigationTitle("Edit Data")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Edit Data")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                }
            }
            .toolbarBackground(Color(red: 0.09, green: 0.36, blue: 0.62), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .tint(.white)
            .onDisappear {
                repository.activeEditField = .none
            }
    }
}

struct MerchantEditUIKitWrapper: UIViewControllerRepresentable {
    let merchant: MerchantModel
    
    @EnvironmentObject var repository: MerchantRepository
    @EnvironmentObject var navigator: AppNavigator
    
    func makeUIViewController(context: Context) -> MerchantEditViewController {
        let vc = MerchantEditViewController()
        vc.merchant = merchant
        vc.repository = repository
        vc.navigator = navigator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MerchantEditViewController, context: Context) {}
}
