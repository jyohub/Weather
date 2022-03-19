//
//  WeatherService.swift
//  Weather
//
//  Created by jyohub on 2022/03/08.
//

import Foundation
import Combine

protocol WeatherServiceProtocol {
    func fetchWeatherData(latitude: Double, longitude: Double) -> AnyPublisher<Weather, Error>
}

class WeatherService: WeatherServiceProtocol {
      
    private var apiKey: String {
        return "261235e5befdb96937cf3a74f54ca67e"
    }
    
    func fetchWeatherData(
        latitude: Double,
        longitude: Double
    ) -> AnyPublisher<Weather, Error> {
        
        guard let weatherURL = URL(
            string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        ) else {
            return Fail(error: APIError.invalidRequestError(.urlInvalid)).eraseToAnyPublisher()
        }
        return URLSession.shared.publisher(for: weatherURL, responseType: Weather.self)
    }
}
