//
//  NetworkError.swift
//  MoviesApp
//
//  Created by Mostafa Abd ElFatah on 5/17/22.
//

import Foundation

enum NetworkAPIError: Error {
    case invalidURL
    case unableToComplete
    case invalidResponse
    case invalidData
    case custom(String)
}

extension NetworkAPIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid url request".localized
        case .unableToComplete:
            return "Unable to complete the task".localized
        case .invalidResponse:
            return "Error in response".localized
        case .invalidData:
            return "Invalid data".localized
        case .custom(let error):
            return error
        }
    }
}
