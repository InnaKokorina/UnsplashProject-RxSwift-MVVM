//
//  HomeViewModel.swift
//  UnsplashProject
//
//  Created by Inna Kokorina on 11.09.2022.
//

import Foundation
import SnapKit
import RealmSwift

protocol HomeViewControllerDelegate: AnyObject {
    func saveFavoriteImages(favorite: Results<ImageRealm>?)
}

class HomeViewModel {
    private var interactor = Interactor()
    private let realm = try! Realm()
    weak var delegate: HomeViewControllerDelegate?
    var token: String?
    var reloadList = {() -> () in }
    var images: Results<ImageRealm>? {
        didSet{
            reloadList()
        }
    }
    // MARK: - internal func
    func fetchData() {
        if realm.isEmpty {
            interactor.getImagesFromNetwork(url: URL(string: "\(Constants.url)\(self.token!)")!) {
                self.dataDidRecive()
            }
        } else {
            dataDidRecive()
        }
        delegate?.saveFavoriteImages(favorite: images?.filter("isSaved=%@", true))
    }
  
    func getImagesCount(images: Results<ImageRealm>?) -> Int {
        if let loadedImages = images {
            return loadedImages.count
        } else {
            return 0
        }
    }
    func updateFavorite(index: Int, completion: ((Bool) -> ()) ) {
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
    // MARK: - private func
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
