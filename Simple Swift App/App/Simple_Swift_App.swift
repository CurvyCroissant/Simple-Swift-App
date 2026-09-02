// App/Simple_Swift_App.swift

import SwiftUI

@main
struct Simple_Swift_App: App {
    @StateObject private var navigator = AppNavigator()
    @StateObject private var repository = MerchantRepository()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigator.path) {
                MerchantFormView()
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case let .photoUpload(merchant):
                            MerchantPhotoView(merchant: merchant)
                        case let .details(merchant):
                            MerchantDetailsView(merchant: merchant)
                        case let .result(merchant):
                            MerchantFormResultView(merchant: merchant)
                        case let .editField(merchant):
                            MerchantEditView(merchant: merchant)
                        }
                    }
            }
            .environmentObject(navigator)
            .environmentObject(repository)
        }
    }
}
