//
//  AppDelegate.swift
//  MaxMakDemo
//
//  Created by maxmak on 2020/10/29.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = UIColor.white
        self.window!.makeKeyAndVisible()
        let nav = UINavigationController(rootViewController: DisplayController())

        self.window?.rootViewController = nav
        
        return true
    }
}
