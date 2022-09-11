//
//  HomeViewController.swift
//  UnsplashProject
//
//  Created by Inna Kokorina on 27.06.2022.
//
import UIKit
import SnapKit
import RealmSwift

class HomeViewController: UIViewController {
   
    var viewModel: HomeViewModel?
  //  weak var delegate: HomeViewControllerDelegate?
    
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
        searchBar.delegate = self
        loadPosts()
    }
    private func tableViewsSetup() {
        view.backgroundColor = .black
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func loadPosts() {
        viewModel?.fetchData()
            viewModel?.reloadList = { [weak self] ()  in
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
    //   tableView.reloadData()
    }
}
// MARK: - UITableViewDataSource, UITableViewDelegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        print(viewModel.getImagesCount(images: viewModel.images))
       return viewModel.getImagesCount(images: viewModel.images)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.cellId, for: indexPath) as? HomeTableViewCell else { return UITableViewCell() }
        
        if let loadedImages = viewModel?.images {
            cell.configure(image: loadedImages[indexPath.row])
            cell.saveButtonTap = {
                self.viewModel?.updateFavorite(loadedImages: loadedImages, index: indexPath.row) { saved in
                    if saved {
                        cell.favoriteButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                    } else {
                        cell.favoriteButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
                    }
            //        self.delegate?.saveFavoriteImages(favorite: loadedImages)
                }
                
            }
        }
        return cell
    }
}
// MARK: - ModelManagerDelegate

extension HomeViewController: FavoriteViewControllerDelegate {
    func deteleFromFavorite() {
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
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
// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.images = viewModel?.images?.filter("user CONTAINS[cd] %@", searchBar.text!)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadPosts()
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
