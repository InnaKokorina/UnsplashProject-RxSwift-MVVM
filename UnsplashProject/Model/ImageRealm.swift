//
//  ImageRealm.swift
//  UnsplashProject
//
//  Created by Inna Kokorina on 27.06.2022.
//

import Foundation
import RealmSwift

class ImageRealm: Object {
    @Persisted var id: String
    @Persisted var user: String
    @Persisted var imageUrl: String
    @Persisted var isSaved: Bool
    
    convenience init(id: String, user: String, imageUrl: String, isSaved: Bool) {
        self.init()
        self.id = id
        self.user = user
        self.imageUrl = imageUrl
        self.isSaved = isSaved
    }
    override class func primaryKey() -> String? {
        return "id"
      }
    
}
