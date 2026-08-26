////
////  SceneDelegate.swift
////  Simple Swift App
////
////  Created by ITBCA on 20/08/26.
////
//
//// BOILERPLATE (almost all). Grabs the windowScene and instantiates UIWindow
//
//import UIKit
//
//// Manages a single instance of the app's UI (scene).
//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//    var window: UIWindow? // the app's invisible root container
//    
//    func scene(
//        _ scene: UIScene,
//        willConnectTo session: UISceneSession,
//        options connectionOptions: UIScene.ConnectionOptions
//    ) {
//        // windowScene is the available physical screen space
//        guard let windowScene = (scene as? UIWindowScene) else {
//            return
//        }
//        
//        let window = UIWindow(windowScene: windowScene)
//        let mainViewController = UIKitMerchantFormViewController()
//        let navigationController = UINavigationController(rootViewController: mainViewController)
//        
//        window.rootViewController = navigationController // define the starting point of the app's visual hierarchy
//        window.makeKeyAndVisible() // pushes window to screen and directs user input events to it
//        
//        self.window = window
//    }
//}
