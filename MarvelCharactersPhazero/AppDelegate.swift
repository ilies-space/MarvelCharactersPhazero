//
//  AppDelegate.swift
//  MarvelCharactersPhazero
//
//  Created by ilies Ould menouer on 4/9/2024.
//

import Foundation
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13.0, *) {
            // SceneDelegate handles this
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
            let navigationController = UINavigationController(rootViewController: CharacterListViewController())
            window?.rootViewController = navigationController
            window?.backgroundColor = .white // Set background color for window to confirm it is working
            window?.makeKeyAndVisible()
        }
        return true
    }
}
