//
//  AppDelegate.swift
//  Cooky
//
//  Created by Aslan Murat on 15.07.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let customNavBarAppearance = UINavigationBarAppearance()
        customNavBarAppearance.configureWithOpaqueBackground()
        customNavBarAppearance.backgroundColor = .systemBackground
        
        let green = UIColor.init(red: 15/255, green: 92/255, blue: 100/255, alpha: 1)
        customNavBarAppearance.titleTextAttributes = [.foregroundColor: green]
        customNavBarAppearance.largeTitleTextAttributes = [.foregroundColor: green]
        
        let barButtonItemAppearance = UIBarButtonItemAppearance(style: .plain)
        barButtonItemAppearance.normal.titleTextAttributes = [.foregroundColor: green]
        customNavBarAppearance.buttonAppearance = barButtonItemAppearance
        
        UINavigationBar.appearance().standardAppearance = customNavBarAppearance
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        PersistenceManager.shared.saveFavoriteRecipes()
    }
    
}

