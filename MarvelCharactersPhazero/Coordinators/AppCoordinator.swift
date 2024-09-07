//
//  AppCoordinator.swift
//  MarvelCharactersPhazero
//
//  Created by ilies Ould menouer on 6/9/2024.
//

import UIKit

class AppCoordinator {
    var window: UIWindow?
    var navigationController: UINavigationController?
    
    func start() {
        let characterListVC = CharacterListViewController()
        navigationController = UINavigationController(rootViewController: characterListVC)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
