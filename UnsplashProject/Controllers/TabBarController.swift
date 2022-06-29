//
//  TabBarController.swift
//  UnsplashProject
//
//  Created by Inna Kokorina on 27.06.2022.
//

import UIKit


class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .white
        tabBar.isTranslucent = false
        self.tabBarItem.imageInsets = UIEdgeInsets(top: -10, left: 0, bottom: -4, right: 0)
        setupViewControllers()
        customTabAndNavigationBar()
    }

    func setupViewControllers() {
        let homeVC = HomeViewController()
        let favoriteVC = FavoriteViewController()
        let homeNavVC = UINavigationController(rootViewController: homeVC)
        homeNavVC.navigationBar.backgroundColor = .black
        let favoriteVCNav = UINavigationController(rootViewController: favoriteVC)
        homeVC.delegate = favoriteVC
        favoriteVC.delegate = homeVC
        setViewControllers([homeNavVC, favoriteVCNav], animated: true)
        guard let items = self.tabBar.items else { return }
        let images = ["house", "bookmark"]
        let title = ["Home", "Saved"]
        for index in 0..<items.count {
            items[index].image = UIImage(systemName: images[index])
            items[index].title = title[index]
        }
        
    }
    func customTabAndNavigationBar(){
        if #available(iOS 15, *) {
                        let navigationBarAppearance = UINavigationBarAppearance()
                        navigationBarAppearance.configureWithOpaqueBackground()
                        navigationBarAppearance.titleTextAttributes = [
                            NSAttributedString.Key.foregroundColor : UIColor.white
                        ]
                        navigationBarAppearance.backgroundColor = UIColor.black
                        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
                        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
                        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
                    
                    let tabBarApperance = UITabBarAppearance()
                    tabBarApperance.configureWithOpaqueBackground()
                    tabBarApperance.backgroundColor = UIColor.black
                    UITabBar.appearance().scrollEdgeAppearance = tabBarApperance
                    UITabBar.appearance().standardAppearance = tabBarApperance
                }
    }
}
