//
//  WeatherViewModelTests.swift
//  WeatherTests
//
//  Created by jyohub on 2022/03/14.
//

import XCTest
import Combine
import CoreLocation

@testable import Weather

class WeatherViewModelTests: XCTestCase {

    var sut: WeatherViewModelProtocol!
    var mockWeatherService: MockWeatherService!
    var mockLocationManager: MockLocationManager!
    
    override func setUp() {
        super.setUp()
        mockWeatherService = MockWeatherService()
        mockLocationManager = MockLocationManager()
        sut = WeatherViewModel(weatherService: mockWeatherService, locationManager: mockLocationManager)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testSuccessfulLocationFetch() throws {
        mockLocationManager.isSuccessResponse = true
        sut.fetchLocation()
        let locationFetchState = try awaitValue(of: sut.locationFetchState)
        XCTAssertNotNil(locationFetchState)
        XCTAssertEqual(locationFetchState.count, 1)
    }
    
    func testWeatherDataFetchSuccessful() throws {
        sut.fetchWeatherData(location: CLLocation(latitude: 10.5, longitude: 150))
        let weather = try awaitValue(of: sut.currentWeather)
        XCTAssertNotNil(weather)

        XCTAssertEqual(weather[0]!.place, "Tokyo")
        XCTAssertEqual(weather[0]!.country, "JP")
        XCTAssertEqual(weather[0]!.icon, "03d")
        XCTAssertEqual(weather[0]!.description, "sunny")
        XCTAssertEqual(weather[0]!.temperature, 25)
    }
}

class MockWeatherService: WeatherServiceProtocol {
    func fetchWeatherData(latitude: Double, longitude: Double) -> AnyPublisher<Weather, Error> {
        return Just(Weather(time: Date(), description: "sunny", place: "Tokyo", country: "JP", icon: "03d", temperature: 25))
            .tryMap{ $0 }
            .eraseToAnyPublisher()
    }
}

class MockLocationManager: LocationManagerProtocol {
    
    var isSuccessResponse = false
    
    func requestWhenInUseAuthorization() -> Future<Void, LocationError> {
        if isSuccessResponse {
            return Future { promise in
                promise(.success(()))
            }
        } else {
            return Future { promise in
                promise(.failure(.unauthorized))
            }
        }
    }
    
    func requestLocation() -> Future<CLLocation, LocationError> {
        if isSuccessResponse {
            return Future { promise in
                promise(.success(CLLocation(latitude: 10.5, longitude: 150)))
            }
        } else {
            return Future { promise in
                promise(.failure(.unauthorized))
            }
        }
        
        
    }
}
