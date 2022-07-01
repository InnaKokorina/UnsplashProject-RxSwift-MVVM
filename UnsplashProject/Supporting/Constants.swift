//
//  Constants.swift
//  UnsplashProject
//
//  Created by Inna Kokorina on 30.06.2022.
//

import Foundation

struct Constants {
    static let redirectURL = Bundle.main.infoDictionary?["REDIRECT_URL"] as? String
    static let accessKey = Bundle.main.infoDictionary?["ACCESS_KEY"] as? String
    static let secretKey = Bundle.main.infoDictionary?["SECRET_KEY"] as? String
    static let grant_type = "authorization_code"
    static let url = "https://api.unsplash.com/photos/?client_id="
}
