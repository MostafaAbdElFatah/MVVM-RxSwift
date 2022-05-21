//
//  MoviesAPIsManagerProtocolMock.swift
//  MoviesAppTests
//
//  Created by Mostafa Abd ElFatah on 5/21/22.
//

import Foundation
@testable import MoviesApp


class MoviesAPIsManagerProtocolMock: MoviesAPIsManagerProtocol {
    
    var fetchMoviesIsCalled = false
    
    var response:MoviesReponse!
    var handler:((Result<MoviesReponse, NetworkAPIError>) -> Void)?
    
    func fetchMovies(from url: URL, completionHandler handler: @escaping (Result<MoviesReponse, NetworkAPIError>) -> Void) {
        fetchMoviesIsCalled = true
        self.handler = handler
    }
    
    func fetchSuccess() {
        handler?(.success(response))
    }
    
    func fetchFailure(error:NetworkAPIError) {
        handler?(.failure(error))
    }
    
}
