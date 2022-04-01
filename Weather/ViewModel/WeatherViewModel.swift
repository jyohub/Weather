//
//  WeatherViewModel.swift
//  Weather
//
//  Created by jyohub on 2022/03/10.
//

import Foundation
import Combine
import CoreLocation

protocol WeatherViewModelProtocol {
    var locationFetchState: CurrentValueSubject<LocationFetchState, Never> { set get }
    var currentWeather: CurrentValueSubject<Weather?, Never> { set get }
    var errorMessage: CurrentValueSubject<String?, Never> { set get }
    var widgetTypes: [WeatherWidgetType] { get }

    func fetchLocation()
    func fetchWeatherData(location: CLLocation) 
}

enum LocationFetchState: Equatable {
    case isLoading
    case failed(LocationError)
    case loaded(CLLocation)
}

class WeatherViewModel: ObservableObject, WeatherViewModelProtocol {
    
    var locationFetchState: CurrentValueSubject<LocationFetchState, Never> = .init(.isLoading)
    var currentWeather: CurrentValueSubject<Weather?, Never> = .init(nil)
    var errorMessage: CurrentValueSubject<String?, Never> = .init(nil)
    
    private(set) var weather: Weather?
    private var location: CLLocation?
    private var cancellables = Set<AnyCancellable>()

    var widgetTypes: [WeatherWidgetType] {
       return [.small, .medium, .large ]
    }
    
    private let weatherService: WeatherServiceProtocol
    private let locationManager: LocationManagerProtocol

    init(weatherService: WeatherServiceProtocol, locationManager: LocationManagerProtocol) {
        self.weatherService = weatherService
        self.locationManager = locationManager
    }
    
    func fetchLocation() {
        locationFetchState.send(.isLoading)
        locationManager.requestWhenInUseAuthorization()
            .flatMap { self.locationManager.requestLocation() }
            .asResult()
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let location):
                    self?.location = location
                    self?.locationFetchState.send(.loaded(location))
                case .failure(let error):
                    self?.locationFetchState.send(.failed(error))
                }
            }).store(in: &cancellables)
    }
    
    func fetchWeatherData(location: CLLocation) {
        weatherService
            .fetchWeatherData(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
            .receive(on: RunLoop.main)
            .asResult()
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let weather):
                    print(weather)
                    self?.weather = weather
                    self?.currentWeather.send(weather)
                    NotificationCenter.default.post(name: .weatherUpdated, object: self?.currentWeather)
                case .failure(let error):
                    guard let error = error as? APIError else  { return }
                    self?.weather = nil
                    self?.errorMessage.send(error.errorDescription)
                }
            }).store(in: &cancellables)
    }
}





