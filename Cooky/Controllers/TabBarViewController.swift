//
//  TabBarController.swift
//  Cooky
//
//  Created by Aslan Murat on 30.07.2022.
//

import UIKit

class TabBarViewController: UITabBarController {
    private let vc1 = MainViewController()
    private let vc2 = FavoriteRecipesViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        vc1.navigationItem.largeTitleDisplayMode = .always
        vc2.navigationItem.largeTitleDisplayMode = .always

        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)

        nav1.navigationBar.tintColor = .label
        nav2.navigationBar.tintColor = .label

        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "heart"), tag: 1)
        
        tabBar.tintColor = .init(red: 15/255, green: 92/255, blue: 100/255, alpha: 1)

        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true

        setViewControllers([nav1, nav2], animated: false)
    }

}
