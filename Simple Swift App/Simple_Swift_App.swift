//
//  Simple_Swift_App.swift
//  Simple Swift App
//
//  Created by ITBCA on 19/08/26.
//

import SwiftUI

@main
struct Simple_Swift_App: App {
    
    // navigation's single source of truth
    @StateObject private var navigator = AppNavigator()
    
    var body: some Scene {
        WindowGroup {
            MerchantFormView()
            
                // inject it into environment
                .environmentObject(navigator)
        }
    }
}
