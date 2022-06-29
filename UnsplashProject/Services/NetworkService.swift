//
//  NetworkService.swift
//  UnsplashProject
//
//  Created by Inna Kokorina on 27.06.2022.
//

import Foundation
class NetworkService {
    static let shared = NetworkService()
    private init (){}
    
    func getImagesData(url: URL, completion:@escaping ([ImageModel]?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                let imagesData = try JSONDecoder().decode([ImageModel].self, from: data!)
                completion(imagesData)
             
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
}
