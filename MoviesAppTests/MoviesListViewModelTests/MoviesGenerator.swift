//
//  MoviesGenerator.swift
//  MoviesAppTests
//
//  Created by Mostafa Abd ElFatah on 5/21/22.
//

import Foundation
@testable import MoviesApp


class MoviesGenerator {
    
    func moviesPhotos() -> MoviesReponse? {
        guard let path = Bundle.unitTest.path(forResource: "movies", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
                return nil
        }

        let respnse = try? JSONDecoder().decode(MoviesReponse.self, from: data)
        return respnse
    }
    
}
