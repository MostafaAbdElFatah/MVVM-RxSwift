//
//  APIsManager.swift
//  MoviesApp
//
//  Created by Mostafa Abd ElFatah on 5/17/22.
//

import Foundation

enum APIsManager {
    
    public static func fetch<Model>( url: URL, _ val: Model.Type, completionHandler: @escaping (Result<Model, NetworkAPIError>) -> Void) where Model : Decodable, Model : Encodable {
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            
            if let error = error {
                completionHandler(.failure(.custom(error.localizedDescription)))
            }
            
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                completionHandler(.failure(.invalidResponse))
//                return
//            }
            
            guard let data = data else {
                completionHandler(.failure(.invalidData))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(Model.self, from: data)
                completionHandler(.success(decodedResponse))
            } catch {
                print(error)
                completionHandler(.failure(.custom(error.localizedDescription)))
            }
        }
        task.resume()
    }
    
    
}
