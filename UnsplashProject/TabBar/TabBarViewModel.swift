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
        
        let homeViewModel = HomeViewModel()
        let favoriteViewModel = FavoriteViewModel()
        
        homeVC.viewModel = homeViewModel
        favoriteVC.viewModel = favoriteViewModel
        
        homeViewModel.delegate = favoriteViewModel
        homeViewModel.token = token
        
        favoriteViewModel.delegate = homeViewModel
        
        return [homeNavVC, favoriteVCNav]
    }
}
