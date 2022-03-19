//
//  WeatherWidgetViewModel.swift
//  Weather
//
//  Created by jyohub on 2022/03/10.
//

import UIKit
import Combine
import CoreLocation
import WidgetKit

class WeatherWidgetViewModel: ObservableObject {
    
    @Published private(set) var entry: WeatherEntry?
    @Published private(set) var isWidgetScreen: Bool = false
    @Published private(set) var imageSaved: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private let weatherService: WeatherServiceProtocol
    private let locationManager: LocationManagerProtocol

    init(entry: WeatherEntry? = nil,
         isWidgetScreen: Bool = true,
         weatherService: WeatherServiceProtocol = WeatherService(),
         locationManager: LocationManagerProtocol = LocationManager()) {
        self.entry = entry
        self.isWidgetScreen = isWidgetScreen
        self.weatherService = weatherService
        self.locationManager = locationManager
        setupImageSavedNotificationObserver()
    }
    
    private func setupImageSavedNotificationObserver() {
        NotificationCenter
            .default
            .addObserver(
                self,
                selector: #selector(imageSaved(notification:)),
                name: .imageSaved, object: nil
            )
    }
    
    @objc func imageSaved(notification: NSNotification) {
        imageSaved = true
    }
    
    func setEntry(entry: WeatherEntry) {
        self.entry = entry
    }
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        return FileManager.default.loadBackgroundImage(fileName: fileName)
    }
    
    func fetchWeatherData(completion: @escaping (Timeline<WeatherEntry>) -> Void) {
        locationManager.requestWhenInUseAuthorization()
            .flatMap { self.locationManager.requestLocation() }
            .receive(on: RunLoop.main)
            .asResult()
            .sink(receiveValue: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let location):
                    self.fetchWeather(location: location, completion: completion)
                case .failure(let error):
                    let entry = WeatherEntry(date: Date(), weather: nil, errorMessage: error.errorDescription)
                    let currentDate =  Date()
                    guard let refreshDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate) else { return }
                    let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                    completion(timeline)
                }
            }).store(in: &self.cancellables)
    }
    
    private func fetchWeather(location: CLLocation, completion: @escaping (Timeline<WeatherEntry>) -> Void) {
        let currentDate =  Date()
        guard let refreshDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate) else { return }
        
        self.weatherService
            .fetchWeatherData(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
            .receive(on: RunLoop.main)
            .asResult()
            .sink(receiveValue: { result in
                switch result {
                case .success(let weather):
                    let entry = WeatherEntry(date: Date(), weather: weather, errorMessage: nil)
                    let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                    completion(timeline)
                case .failure(let error):
                    guard let error = error as? APIError else  { return }
                    let entry = WeatherEntry(date: Date(), weather: nil, errorMessage: error.errorDescription)
                    let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                    completion(timeline)
                }
            }).store(in: &self.cancellables)
    }
}
