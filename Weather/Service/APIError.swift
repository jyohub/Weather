//
//  APIError.swift
//  Weather
//
//  Created by jyohub on 2022/03/13.
//

import Foundation

enum APIError: Error {
    case invalidRequestError(String)
    case networkError(Error)
    case invalidResponse
    case validationError
    case decodingError(Error)
    case serverError(statusCode: Int)
    
    var errorDescription: String {
        switch self {
        case .invalidRequestError(let message):
            return "Invalid request: \(message)"
        case .networkError(let error):
            print("Network error: \(error)")
            return "Network error occurred. The internet connection appears to be offline."
        case .invalidResponse:
            return "Server error occured. Invalid response."
        case .validationError:
            return "Server Validation error occured."
        case .decodingError:
            return "The server returned data in an unexpected format."
        case .serverError(let statusCode):
            print( "Server error with code \(statusCode))")
            return "Server error occured. Please try after sometime"
        }
    }
}
