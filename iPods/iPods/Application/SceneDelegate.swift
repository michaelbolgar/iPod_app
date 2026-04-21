//
//  SceneDelegate.swift
//  iPods
//
//  Created by Михаил Болгар on 13.04.2026.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        let startVC = HomeViewController()

       // let startVC = ViewController()


       // let startVC = ViewController()
        let navController = UINavigationController(rootViewController: startVC)

        window?.makeKeyAndVisible()
        window?.rootViewController = navController
    }
}
