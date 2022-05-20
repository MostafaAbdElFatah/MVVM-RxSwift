//
//  MoviesNetworkManagerMock.swift
//  MoviesAppTests
//
//  Created by Mostafa Abd ElFatah on 5/18/22.
//

import Foundation

@testable import MoviesApp


class MoviesAPIsManagerMock:MoviesAPIsManagerProtocol{
    
    var fetchMoviesIsCalled = false
    
    var completionHandler: ((Result<MoviesReponse, NetworkAPIError>) -> Void)!
    var response = MoviesReponse(photosList: PhotosList(page: 1, pages: 10, perpage: 20, total: 100, photos: []), stat: "")

    
    func fetchMovies(from url: URL, completionHandler: @escaping (Result<MoviesReponse, NetworkAPIError>) -> Void) {
        fetchMoviesIsCalled = true
        self.completionHandler = completionHandler
    }
    
    
    func fetchSuccess(){
        completionHandler(.success(response))
    }
    
    func fetchFailure(error:NetworkAPIError){
        completionHandler(.failure(error))
    }
    
    
}
