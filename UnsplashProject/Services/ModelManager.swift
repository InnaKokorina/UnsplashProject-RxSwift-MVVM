//
//  ModelManager.swift
//  UnsplashProject
//
//  Created by Inna Kokorina on 27.06.2022.
//

import Foundation
import RealmSwift
protocol ModelManagerDelegate: AnyObject {
    func dataDidRecive(data: List<ImageRealm>)
    func dataDidReciveImagesFromDataBase(data: Results<ImageRealm>)
}

class ModelManager {
    weak var delegate: ModelManagerDelegate?
    private let realm = try! Realm()
       
    func getImagesFromNetwork() {
        let imagesArray = List<ImageRealm>()
        let url = URL(string: "YOURURL")!
        NetworkService.shared.getImagesData(url: url) { [unowned self] data in
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
            DispatchQueue.main.async { [unowned self] in
            self.saveImagesToDataBase(model: imagesArray)
            self.delegate?.dataDidRecive(data: imagesArray)
            }
        }
    }
    
    func saveImagesToDataBase(model: List<ImageRealm>) {
            do  {
                try self.realm.write {
                    self.realm.add(model, update: .modified)
                }
            } catch {
                print("database error")
            }
    }
    func fetchImagesFromDataBase() {
        let realmImages = realm.objects(ImageRealm.self)
        
        guard !realmImages.isEmpty else {
            return
        }
        
        delegate?.dataDidReciveImagesFromDataBase(data: realmImages)
    }
}
