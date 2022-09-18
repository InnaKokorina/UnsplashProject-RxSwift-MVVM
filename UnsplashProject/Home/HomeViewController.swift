//
//  HomeViewController.swift
//  UnsplashProject
//
//  Created by Inna Kokorina on 27.06.2022.
//
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
   
    var viewModel: HomeViewModelProtocol?
    let disposeBag = DisposeBag()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.cellId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        return tableView
    }()
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "searching..."
        searchBar.tintColor = .white
        searchBar.barTintColor = .white
        searchBar.searchTextField.textColor = .white
        return searchBar
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewsSetup()
        setupNavItems()
        loadPosts()
    }
    
    private func tableViewsSetup() {
        view.backgroundColor = .black
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func loadPosts() {
        viewModel?.fetchData() {
            self.viewModel?.bind(tableView: self.tableView, searchBar: self.searchBar)
        }
    }
}

// MARK: - navigationItems
extension HomeViewController {
    func setupNavItems() {
        navigationController?.navigationBar.backgroundColor = .black
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
    }
}
