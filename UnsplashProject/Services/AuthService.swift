//
//  AuthService.swift
//  UnsplashProject
//
//  Created by Inna Kokorina on 30.06.2022.
//

import Foundation
import Alamofire

class AuthService {
    
    func fetchAccessToken(code: String, completion: @escaping (String) -> Void) {
        let url = "https://unsplash.com/oauth/token"
        let parameters = [
            "client_id": Constants.accessKey ?? "",
            "client_secret": Constants.secretKey ?? "",
            "redirect_uri": Constants.redirectURL ?? "",
            "code": "\(code)",
            "grant_type": Constants.grant_type
        ] as Parameters?
        
        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
            if let responseVal = response.value  {
                if let responseJSON = responseVal as? [String:Any] {
                    if let token = responseJSON["access_token"] as? String {
                        print(token)
                        completion(token)
                    }
                }
            } else {
                print("Request AuthToken Error")
            }
        }
    }
}
