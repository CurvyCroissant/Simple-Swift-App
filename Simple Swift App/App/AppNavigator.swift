// App/AppNavigator.swift

import SwiftUI
import Combine

enum Route: Hashable {
    case result(merchant: MerchantModel)
    case photoUpload(merchant: MerchantModel)
    case details(merchant: MerchantModel)
    case editField(merchant: MerchantModel)
}

class AppNavigator: ObservableObject {
    @Published var path = [Route]()
    
    func jumpToEdit(route: Route?) {
        if let route = route {
            // Rebuild stack directly to target page
            path = [route]
        } else {
            popToRoot()
        }
    }
    
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
