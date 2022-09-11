//
//  AuthViewModel.swift
//  UnsplashProject
//
//  Created by Inna Kokorina on 11.09.2022.
//

import Foundation

class AuthViewModel {
    private var authService = AuthService()
    
    func webWiewLoad(completion: ((URLRequest) ->())) {
        let url = URL(string: "https://unsplash.com/oauth/authorize?client_id=\(Constants.accessKey ?? "")&redirect_uri=\(Constants.redirectURL ?? "")&response_type=code&scope=public")!
        let request = URLRequest(url: url)
        completion(request)
    }
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
    func fetchToken(code: String, completion: @escaping (String) -> Void) {
        authService.fetchAccessToken(code: code) { data in
            completion(data)
        }
    }
}
