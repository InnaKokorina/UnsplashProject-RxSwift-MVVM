//
//  HomeViewModel.swift
//  UnsplashProject
//
//  Created by Inna Kokorina on 11.09.2022.
//

import Foundation
import SnapKit
import RealmSwift
import RxSwift
import RxCocoa

protocol HomeViewModelProtocol {
    var reloadList: (() -> ()) { get set }
    var images: Results<ImageRealm>? { get set}
    func fetchData(completion: @escaping () ->())
    func bind(tableView: UITableView, searchBar: UISearchBar)
}

protocol HomeViewControllerDelegate: AnyObject {
    func saveFavoriteImages(favorite: Results<ImageRealm>?)
}

class HomeViewModel: HomeViewModelProtocol {
    private var interactor = Interactor()
    private let realm = try! Realm()
    weak var delegate: HomeViewControllerDelegate?
    var token: String?
    var items = PublishSubject<Results<ImageRealm>>() // ???
    let disposeBag = DisposeBag()
    var reloadList = {() -> () in }
    var images: Results<ImageRealm>? {
        didSet{
            reloadList()
        }
    }
    
    // MARK: - internal func
    func fetchData(completion: @escaping () -> ()) {
        if realm.isEmpty {
            interactor.getImagesFromNetwork(url: URL(string: "\(Constants.url)\(self.token!)")!) {
                self.dataDidRecive()
                completion()
            }
        } else {
            dataDidRecive()
            completion()
        }
        delegate?.saveFavoriteImages(favorite: images?.filter("isSaved=%@", true))
    }
    
    func bind(tableView: UITableView, searchBar: UISearchBar) {
        // обновление таблицы
        if let images = images {
            let observable = Observable.just(images)
            let search = searchBar.rx.text
                .distinctUntilChanged()
            
            Observable.combineLatest(observable, search) { [unowned self] (allImages, search) -> Results<ImageRealm> in
                return self.filterImages(with: allImages, query: search)
            }
            .bind(to: tableView.rx.items(cellIdentifier: "HomeTableViewCell")) { row, image, cell in
                let myCell = cell as? HomeTableViewCell
                myCell?.configure(image: image)
                // нажатие на save
        myCell?.favoriteButton.rx.tap.asDriver().drive(onNext: {
                    self.updateFavorite(index: row) { saved in
                        if saved {
                            myCell?.favoriteButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                        } else {
                            myCell?.favoriteButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
                        }
                    }
                }).disposed(by: self.disposeBag)
            }
        }
    }
    
    // MARK: - private func
    
    private func filterImages(with allImages: Results<ImageRealm>, query: String?) -> Results<ImageRealm> {
        if query == "" || query == nil {
            return allImages
        } else {
            return allImages.filter("user CONTAINS[cd] %@", query)
        }
    }
    
    private func updateFavorite(index: Int, completion: ((Bool) -> ()) ) {
        do {
            try self.realm.write {
                if let images = images {
                    images[index].isSaved.toggle()
                    if images[index].isSaved {
                        completion(true)
                    } else {
                        completion(false)
                    }
                    self.delegate?.saveFavoriteImages(favorite: self.images)
                }
            }
        } catch {
            print("Error saving Data context \(error)")
        }
    }
    
    private func dataDidRecive() {
        interactor.fetchImagesFromDataBase { results in
            self.images = results.sorted(byKeyPath: "id", ascending: false)
        }
    }
}
// MARK: - FavoriteViewModelDelegate
extension HomeViewModel: FavoriteViewModelDelegate {
    func deteleFromFavorite(images: Results<ImageRealm>?) {
        reloadList()
    }
}
