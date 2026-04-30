//
//  SceneDelegate.swift
//  iPods
//
//  Created by Михаил Болгар on 13.04.2026.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    ///  Temporary test screen for Share and deep link demo
    
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//           guard let windowScene = (scene as? UIWindowScene) else { return }
//           
//           window = UIWindow(windowScene: windowScene)
//        
    /// Temporary test screen. Remove when Details screen is ready
//        
//           let testVC = ShareTestViewController(podcastId: 123)
//           let navController = UINavigationController(rootViewController: testVC)
//           window?.rootViewController = navController
//           
//           window?.makeKeyAndVisible()
//       }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: OnboardingVC.hasSeenOnboardingKey)
        //let startVC = HomeVC_Matin()


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
    
    /// Handles incoming deep links with URL scheme "podcastapp://episode?id=..."
//    
//    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
//            guard let url = URLContexts.first?.url,
//                  let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
//                  components.scheme == "podcastapp",
//                  components.host == "episode" else { return }
//            
//            let queryItems = components.queryItems ?? []
//            if let idString = queryItems.first(where: { $0.name == "id" })?.value,
//               let id = Int(idString) {
//                let shareVC = ShareTestViewController(podcastId: id)
//                let navController = UINavigationController(rootViewController: shareVC)
//                window?.rootViewController = navController
//                window?.makeKeyAndVisible()
//            }
        }
