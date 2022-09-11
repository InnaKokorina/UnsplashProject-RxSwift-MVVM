//
//  HomeInteractor.swift
//  UnsplashProject
//
//  Created by Inna Kokorina on 27.06.2022.
//

import Foundation
import RealmSwift

class Interactor {
    private let realm = try! Realm()
    
    func getImagesFromNetwork(url: URL, completion: @escaping (() ->())) {
        let imagesArray = List<ImageRealm>()
        let url = URL(string: "https://api.unsplash.com/photos/?client_id=\(Constants.accessKey ?? "")")!
        NetworkService.shared.getImagesData(url: url) { data in
            guard let resultData = data
            else {
                print("error in parsing")
                return
            }
            var image = ImageRealm()
            for each in resultData {
                image = ImageRealm(id: each.id, user: each.user.name, imageUrl: each.imageUrl.regular, isSaved: false)
                imagesArray.append(image)
            }
            DispatchQueue.main.async { [weak self] in
                self?.saveImagesToDataBase(model: imagesArray)
                completion()
            }
        }
    }
    func fetchImagesFromDataBase(completion: ((Results<ImageRealm>) -> ())) {
        let realmImages = realm.objects(ImageRealm.self)
        
        guard !realmImages.isEmpty else {
            return
        }
        completion(realmImages)
    }
    private func saveImagesToDataBase(model: List<ImageRealm>) {
        do  {
            try self.realm.write {
                self.realm.add(model, update: .modified)
            }
        } catch {
            print("database error")
        }
    }
}
