//
//  HomeViewController.swift
//  UnsplashProject
//
//  Created by Inna Kokorina on 27.06.2022.
//
import UIKit
import SnapKit
import RealmSwift
protocol HomeViewControllerDelegate: AnyObject {
    func saveFavoriteImages(favorite: Results<ImageRealm>?)
}

class HomeViewController: UIViewController {
    private let modelManager = ModelManager()
    private var images: Results<ImageRealm>?
    private let realm = try! Realm()
    weak var delegate: HomeViewControllerDelegate?
    var token: String?
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
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewsSetup()
        setupNavItems()
        modelManager.delegate = self
        searchBar.delegate = self
        loadPosts()
    }
    func tableViewsSetup() {
        view.backgroundColor = .black
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self  
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    func loadPosts() {
        if realm.isEmpty {
        modelManager.getImagesFromNetwork(url: URL(string: "https://api.unsplash.com/photos/?client_id=\(token!)")!)
        } else {
            modelManager.fetchImagesFromDataBase()
        }
        delegate?.saveFavoriteImages(favorite: images?.filter("isSaved=%@", true))
       
    }
}
// MARK: - UITableViewDataSource, UITableViewDelegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let loadedImages = images {
            return loadedImages.count
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.cellId, for: indexPath) as? HomeTableViewCell else { return UITableViewCell() }
        if let loadedImages = images {
            cell.configure(image: loadedImages[indexPath.row])
            cell.saveButtonTap = {
                do {
                    try self.realm.write {
                        loadedImages[indexPath.row].isSaved.toggle()
                        if loadedImages[indexPath.row].isSaved {
                            cell.favoriteButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)     
                        } else {
                            cell.favoriteButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
                        }
                        self.delegate?.saveFavoriteImages(favorite: self.images)
                    }
                } catch {
                    print("Error saving Data context \(error)")
                }
            }
        }
        return cell
    }
}
extension HomeViewController: ModelManagerDelegate {
    func dataDidReciveImagesFromDataBase(data: Results<ImageRealm>) {
        self.images = data
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func dataDidRecive(data: List<ImageRealm>) {
        modelManager.fetchImagesFromDataBase()
    }
}
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
        UINavigationBar.appearance().backgroundColor = .black
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().isTranslucent = false
        UIBarButtonItem.appearance().tintColor = .white
    }
}
// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        images = images?.filter("user CONTAINS[cd] %@", searchBar.text!)
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

