//
//  APIManager.swift
//  Cooky
//
//  Created by Aslan Murat on 21.07.2022.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    func getPopularRecipes(completion: @escaping (Result<[Recipe], Error>) -> Void) {
        let headers = [
            "X-RapidAPI-Key": "7da2270e0cmshc887a4e83a72413p18d32ejsnb615cba0bfcd",
            "X-RapidAPI-Host": "tasty.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://tasty.p.rapidapi.com/recipes/list?from=0&size=20&tags=summer")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) {
            (data, _, error) in
            guard error == nil else {
                return
            }
            
            guard data != nil else {
                return
            }
            
            do {
                let recipes = try JSONDecoder().decode(Welcome.self, from: data!)
                completion(.success(recipes.results))
//                let dt = try JSONSerialization.jsonObject(with: data!, options: .fragmentsAllowed)
//                print(dt)
            } catch {
                completion(.failure(error))
            }
        }

        dataTask.resume()
    }
}
