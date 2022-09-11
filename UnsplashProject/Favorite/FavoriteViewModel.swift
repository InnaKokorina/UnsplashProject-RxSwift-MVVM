//
//  FavoriteViewModel.swift
//  UnsplashProject
//
//  Created by Inna Kokorina on 11.09.2022.
//

import Foundation
import RealmSwift

protocol FavoriteViewModelDelegate: AnyObject {
    func deteleFromFavorite(images: Results<ImageRealm>?)
}

class FavoriteViewModel {
    private let realm = try! Realm()
    weak var delegate: FavoriteViewModelDelegate?
    var reloadList = {() -> () in }
    var favoriteImages: Results<ImageRealm>? {
        didSet{
            reloadList()
        }
    }
    
    func getFavoriteImagesCount() -> Int {
        if let images = favoriteImages {
            return images.count
        } else {
            return 0
        }
    }
    
    func deleteFavorite(index: Int, completion: (() -> ())) {
        do {
            try self.realm.write {
              //  guard let images = favoriteImages else { return }
                favoriteImages?[index].isSaved.toggle()
                self.delegate?.deteleFromFavorite(images: favoriteImages)
                completion()
            }
        } catch {
            print("Error saving Data context \(error)")
        }
    }
}
// MARK: - HomeViewControllerDelegate
extension FavoriteViewModel: HomeViewControllerDelegate {
    func saveFavoriteImages(favorite: Results<ImageRealm>?) {
        favoriteImages = favorite?.filter("isSaved=%@", true)

    }
}
