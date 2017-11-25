//
//  AppDelegate.swift
//  Architekturen
//
//  Created by Marius Landwehr on 25.11.17.
//  Copyright © 2017 swiftde. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let repoVC = RepositoriesListViewController()
        let navController = UINavigationController(rootViewController: repoVC)
        navController.navigationBar.prefersLargeTitles = true
        window = UIWindow()
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        return true
    }
}

