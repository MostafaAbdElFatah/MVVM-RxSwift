//
//  SQLManagerProtocolMock.swift
//  MoviesAppTests
//
//  Created by Mostafa Abd ElFatah on 5/21/22.
//

import Foundation
@testable import MoviesApp


class DBManagerProtocolMock: DBManagerProtocol {
   
    var isSaveMovie = false
    var isSaveMovies = false
    var isDeleteMovie = false
    var isDeleteAllMovies = false
    var fetchMoviesIsCalled = false
    
    var photoList:[Photo] = []
    
    func fetchMoviesList(currentOffset: Int, pageSize: Int) -> [Photo] {
        fetchMoviesIsCalled = true
        return photoList
    }
    
    func saveMovie(_ photo: Photo) {
        isSaveMovie = true
    }
    
    func saveMovies(_ movies: [Photo]) {
        isSaveMovies = true
    }
    
    func delete(id: String) {
        isDeleteMovie = true
    }
    
    func deleteMovies() {
        isDeleteAllMovies = true
    }
}
