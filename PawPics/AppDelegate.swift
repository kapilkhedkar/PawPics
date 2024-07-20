//
//  AppDelegate.swift
//  PawPics
//
//  Created by Kapil Khedkar on 20/07/24.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
//        let navigationController = UINavigationController(rootViewController: HomeViewController())
//        window?.rootViewController = navigationController
        window?.rootViewController = HomeViewController()
        window?.makeKeyAndVisible()
        return true
    }

}

