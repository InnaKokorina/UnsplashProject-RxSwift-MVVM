//
//  ImageModel.swift
//  UnsplashProject
//
//  Created by Inna Kokorina on 27.06.2022.
//

import Foundation

class ImageModel: Codable {
    var id: String
    var imageDescription: String?
    var user: User
    var imageUrl: ImageUrls
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageDescription = "description"
        case user
        case imageUrl = "urls"
    }
}
struct User: Codable {
    var name: String
    var profileImage: UserProfileImage
    
    enum CodingKeys: String, CodingKey {
        case name
        case profileImage = "profile_image"
    }
}
struct ImageUrls: Codable {
    var regular: String
}

struct UserProfileImage: Codable {
    var large: String
}

