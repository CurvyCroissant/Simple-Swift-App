// Navigation/AppNavigator.swiftN

import SwiftUI
import Combine

enum Route: Hashable {
    case result(merchant: MerchantModel)
    case photoUpload(merchant: MerchantModel)
}

class AppNavigator: ObservableObject {
    @Published var path = [Route]()
    
    func navigate(to route: Route) {
        path.append(route)
    }
    
    func goBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        path.removeAll()
    }
}
