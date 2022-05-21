//
//  URLs.swift
//  MoviesApp
//
//  Created by Mostafa Abd ElFatah on 5/17/22.
//

import Foundation


enum Keys {
    public static let flickerAPIKey = "d17378e37e555ebef55ab86c4180e8dc"
}

enum URLs {
    
    //https://www.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=50&text=Color&page=2&per_page=20&api_key=d17378e37e555ebef55ab86c4180e8dc
    
    private static let flickrRootURL = "https://www.flickr.com/services/rest/";
    
    public static func moviesListURL(page:Int = 1, perPage:Int = 20) -> String{
        "\(flickrRootURL)?method=flickr.photos.search&format=json&nojsoncallback=50&text=Color&page=\(page)&per_page=\(perPage)&api_key=\(Keys.flickerAPIKey)"
    }
}
