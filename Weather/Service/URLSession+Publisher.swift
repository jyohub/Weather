//
//  URLSession+Publisher.swift
//  Weather
//
//  Created by jyohub on 2022/03/12.
//

import Combine
import Foundation

extension URLSession {
    
    func publisher<T: Decodable>(
        for url: URL,
        responseType: T.Type,
        decoder: JSONDecoder = .init()
    ) -> AnyPublisher<T, Error> {
        
        dataTaskPublisher(for: url)
            .mapError { error -> Error in
                return APIError.networkError(error)
            }
            .tryMap { (data, response) -> T in
                print("Received response from server")
                
                guard let urlResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                if urlResponse.statusCode == 400 {
                    throw APIError.validationError
                }
            
                if (500..<600) ~= urlResponse.statusCode {
                    throw APIError.serverError(statusCode: urlResponse.statusCode)
                }
            
                do {
                    return try decoder.decode(T.self, from: data)
                }
                catch {
                    throw APIError.decodingError(error)
                }
            }.eraseToAnyPublisher()
    }
}
