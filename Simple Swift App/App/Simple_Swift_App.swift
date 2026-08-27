// App/Simple_Swift_App.swift

import SwiftUI

@main
struct Simple_Swift_App: App {
    @StateObject private var navigator = AppNavigator()
    @StateObject private var repository = MerchantRepository()
    
    var body: some Scene {
        WindowGroup {
            MerchantFormView()
                .environmentObject(navigator)
                .environmentObject(repository)
        }
    }
}
