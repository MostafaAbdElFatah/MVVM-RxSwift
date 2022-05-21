//
//  State.swift
//  MoviesApp
//
//  Created by Mostafa Abd ElFatah on 5/21/22.
//

import Foundation

public enum State: Equatable {
    case empty
    case loading
    case fetched
    case error(String)
}
