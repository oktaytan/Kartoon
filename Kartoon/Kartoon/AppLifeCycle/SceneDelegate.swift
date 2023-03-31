//
//  SceneDelegate.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 28.03.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        checkAppStart(window: window)
        
        self.window = window
        self.window?.makeKeyAndVisible()
    }
    
    private func checkAppStart(window: UIWindow) {
        let appStart = UserDefaults.standard.bool(forKey: "appStart")
        if appStart {
            window.rootViewController = ListRouter.crateModule()
        } else {
            window.rootViewController = SplashRouter.createModule()
        }
    }
}

