//
//  SceneDelegate.swift
//  AstroSoft
//
//  Created by Roman Kiruxin on 26.09.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UINavigationController(rootViewController: ListGistsViewController(viewModel: ListGistsViewModel()))
        window?.makeKeyAndVisible()
    }
}

