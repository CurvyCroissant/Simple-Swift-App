//
//  AppNavigator.swift
//  Simple Swift App
//
//  Created by ITBCA on 24/08/26.
//

import SwiftUI
import Combine

// enum: defines all possible destinations as well as the data they require
enum Route: Hashable {
    case result(ktp: String, npwp: String, kodePos: String, namaUsaha: String)
}

// navigator: manages navigation stack
class AppNavigator: ObservableObject {
    
    // array that represents the stack of screens
    @Published var path = [Route]()
    
    // push new screen
    func navigate(to route: Route) {
        path.append(route)
    }
    
    // pop to current screen
    func goBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    // pop everything to return to home screen
    func popToRoot() {
        path.removeAll()
    }
}
