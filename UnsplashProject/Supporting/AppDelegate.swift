//
//  AppDelegate.swift
//  UnsplashProject
//
//  Created by Inna Kokorina on 27.06.2022.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupWindow()
        print(Realm.Configuration.defaultConfiguration.fileURL ?? " no realm link")
        do {
            _ = try Realm()
        } catch {
            print("error instalation realm \(error)")
        }
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        .init(rawValue: UIInterfaceOrientationMask.portrait.rawValue)
    }

    func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController  = TabBarController()
        window?.makeKeyAndVisible()
    }


}

