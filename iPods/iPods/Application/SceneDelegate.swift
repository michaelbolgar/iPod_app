//
//  SceneDelegate.swift
//  iPods
//
//  Created by Михаил Болгар on 13.04.2026.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: OnboardingVC.hasSeenOnboardingKey)

        if hasSeenOnboarding {
            showHome()
        } else {
            let onboarding = OnboardingVC(transitionStyle: .scroll, navigationOrientation: .horizontal)
            window?.rootViewController = onboarding
        }

        window?.makeKeyAndVisible()
    }

    func showHome() {
        let navController = UINavigationController(rootViewController: HomeVC_Madina())
        window?.rootViewController = navController
    }
}

