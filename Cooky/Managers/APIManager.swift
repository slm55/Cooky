//
//  APIManager.swift
//  Cooky
//
//  Created by Aslan Murat on 21.07.2022.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    private enum Constants: String {
        case APIKey = "7e7fbcd509mshe800b28e9a6b988p17f7b1jsn85af606af486"
        case APIHost = "tasty.p.rapidapi.com"
    }
    
    func getRecipesByCategory(category: Category, completion: @escaping (Result<[Recipe], Error>) -> Void) {
        
        let headers = [
            "X-RapidAPI-Key": Constants.APIKey.rawValue,
            "X-RapidAPI-Host": Constants.APIHost.rawValue
        ]
        
        let tag = (category == .Popular) ? "" : "\(category)".lowercased()
        
        var request = URLRequest(url: URL(string: "https://tasty.p.rapidapi.com/recipes/list?from=0&size=20&tags=\(tag)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) {
            (data, _, error) in
            if let error = error as? Error {
                return completion(.failure(error))
            }
            
            guard data != nil else {
                return
            }
            
            do {
                let recipes = try JSONDecoder().decode(Welcome.self, from: data!)
                completion(.success(recipes.results))
            } catch {
                completion(.failure(error))
            }
        }

        dataTask.resume()
    }
    
    func search(with query: String, completion: @escaping (Result<[Recipe], Error>) -> Void) {
        let headers = [
            "X-RapidAPI-Key": Constants.APIKey.rawValue,
            "X-RapidAPI-Host": Constants.APIHost.rawValue
        ]
        
        var request = URLRequest(url: URL(string: "https://tasty.p.rapidapi.com/recipes/list?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")! as URL,
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
                let response = try JSONDecoder().decode(Welcome.self, from: data!)
                completion(.success(response.results))
            } catch {
                completion(.failure(error))
            }
        }

        dataTask.resume()
    }
}
