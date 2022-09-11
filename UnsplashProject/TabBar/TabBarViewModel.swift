//
//  TabBarViewModel.swift
//  UnsplashProject
//
//  Created by Inna Kokorina on 11.09.2022.
//

import Foundation
import UIKit

class TabBarViewModel {
    var token = ""
    
    func setupViewControllers() -> [UIViewController] {
        let homeVC = HomeViewController()
        let favoriteVC = FavoriteViewController()
        let homeNavVC = UINavigationController(rootViewController: homeVC)
        homeNavVC.navigationBar.backgroundColor = .black
        let favoriteVCNav = UINavigationController(rootViewController: favoriteVC)
        homeVC.viewModel = HomeViewModel()
        favoriteVC.viewModel = FavoriteViewModel()
        
        homeVC.viewModel?.delegate = favoriteVC.viewModel
        homeVC.viewModel?.token = token
        
        favoriteVC.viewModel.delegate = homeVC.viewModel
        return [homeNavVC, favoriteVCNav]
    }
}
