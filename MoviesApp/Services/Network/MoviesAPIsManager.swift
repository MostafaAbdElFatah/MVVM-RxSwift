//
//  MoviesAPIsManager.swift
//  MoviesApp
//
//  Created by Mostafa Abd ElFatah on 5/17/22.
//

import Foundation


protocol MoviesAPIsManagerProtocol{
    func fetchMovies(from url:URL, completionHandler: @escaping (Result<MoviesReponse, NetworkAPIError>) -> Void)
}


extension MoviesAPIsManagerProtocol{
    func fetchMovies(from url:URL, completionHandler: @escaping (Result<MoviesReponse, NetworkAPIError>) -> Void){
        fetchMovies(from: url, completionHandler: completionHandler)
    }
}


class MoviesAPIsManager: MoviesAPIsManagerProtocol{

    func fetchMovies(from url:URL, completionHandler: @escaping (Result<MoviesReponse, NetworkAPIError>) -> Void) {
        APIsManager.fetch(url: url, MoviesReponse.self) { result in
            completionHandler(result)
        }
    }

}
