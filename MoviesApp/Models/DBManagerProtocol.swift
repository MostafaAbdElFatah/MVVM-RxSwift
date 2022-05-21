//
//  DBManagerProtocol.swift
//  MoviesApp
//
//  Created by Mostafa Abd ElFatah on 5/21/22.
//

import Foundation

protocol DBManagerProtocol {
    
    func deleteMovies()
    func delete(id:String)
    func saveMovie(_ photo:Photo)
    func saveMovies(_ photos:[Photo])
    func fetchMoviesList(currentOffset:Int, pageSize:Int) -> [Photo]
    
}

extension DBManagerProtocol{
    func fetchMoviesList(currentOffset:Int, pageSize:Int = 20) -> [Photo]{
        fetchMoviesList(currentOffset: currentOffset, pageSize: pageSize)
    }
}
