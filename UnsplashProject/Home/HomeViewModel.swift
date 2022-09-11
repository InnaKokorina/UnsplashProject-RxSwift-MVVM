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
// протокол для viewModel
//protocol HomeViewModelProtocol {
//    var updateViewData: ((ImageRealm) -> ())? { get set}
//}

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
    
    // fetch from database or network
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
    // сохраняем в избранное
    func updateFavorite(loadedImages: Results<ImageRealm>, index: Int, completion: ((Bool) -> ()) ) {
        do {
            try self.realm.write {
                loadedImages[index].isSaved.toggle()
                if loadedImages[index].isSaved {
                    completion(true)
                } else {
                    completion(false)
                }
                self.delegate?.saveFavoriteImages(favorite: self.images)
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

//extension HomeViewModel: ModelManagerDelegate {
    
//    func dataDidReciveImagesFromDataBase(data: Results<ImageRealm>) {
//        self.images = data.sorted(byKeyPath: "id", ascending: false)
//        print(images)
////        DispatchQueue.main.async {[weak self] in
////            self?.tableView.reloadData() // тут должна быть связь с подпиской VC
////        }
//
//    }
    
    
//}
