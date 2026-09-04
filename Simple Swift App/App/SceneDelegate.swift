//  App/SceneDelegate.swift

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: CUSTOM
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // capture window scene
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        // initialize physical window
        let window = UIWindow(windowScene: windowScene)
        
        // define first screen
        let rootVC = MerchantFormViewController()
        
        // initialize global router
        let navigationController = UINavigationController(rootViewController: rootVC)
        
        // UI Kit's .toolbarBackground, .toolbarColorScheme
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.09, green: 0.36, blue: 0.62, alpha: 1.0)
        
        // lock text & icons to white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 17, weight: .heavy)]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        // apply theme globally to router
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
        navigationController.navigationBar.tintColor = UIColor.white
        
        // mount & display
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        self.window = window
    }
    
    // MARK: BOILERPLATE
    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
