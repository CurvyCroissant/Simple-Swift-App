import SwiftUI

@main
struct Simple_Swift_App: App {
    @StateObject private var navigator = AppNavigator()
    
    var body: some Scene {
        WindowGroup {
            MerchantFormView()
                .environmentObject(navigator)
        }
    }
}
