import SwiftUI
import Combine

enum Route: Hashable {
    case result(ktp: String, npwp: String, nomorRekening: String, namaUsaha: String)
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
