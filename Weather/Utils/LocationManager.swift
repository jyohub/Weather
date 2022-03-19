//
//  LocationManager.swift
//  Weather
//
//  Created by jyohub on 2022/03/08.
//

import CoreLocation
import Combine

protocol LocationManagerProtocol {
    func requestWhenInUseAuthorization() -> Future<Void, LocationError>
    func requestLocation() -> Future<CLLocation, LocationError>
}

enum LocationError: Error {
    case unauthorized
    case unableToDetermineLocation
    
    var errorDescription: String {
        switch self {
        case .unauthorized:
            return "Not Authorized. Please provide the location permission in Settings for the App."
        case .unableToDetermineLocation:
            return "Sorry, Unable to determine location."
        }
    }
}

class LocationManager: NSObject {
    private let locationManager = CLLocationManager()
    private var authorizationRequests: [(Result<Void, LocationError>) -> Void] = []
    private var locationRequests: [(Result<CLLocation, LocationError>) -> Void] = []

    override init() {
        super.init()
        locationManager.delegate = self
    }

    private func handleLocationRequestResult(_ result: Result<CLLocation, LocationError>) {
        while locationRequests.count > 0 {
            let request = locationRequests.removeFirst()
            request(result)
        }
    }
}

// MARK: LocationManagerProtocol Conformance
extension LocationManager: LocationManagerProtocol {
    
    func requestWhenInUseAuthorization() -> Future<Void, LocationError> {
        guard locationManager.authorizationStatus == .notDetermined else {
            return Future { $0(.success(())) }
        }

        let future = Future<Void, LocationError> { completion in
            self.authorizationRequests.append(completion)
        }

        locationManager.requestWhenInUseAuthorization()
        return future
    }

    func requestLocation() -> Future<CLLocation, LocationError> {
        guard locationManager.authorizationStatus == .authorizedAlways ||
                locationManager.authorizationStatus == .authorizedWhenInUse else {
            return Future { $0(.failure(LocationError.unauthorized)) }
        }

        let future = Future<CLLocation, LocationError> { completion in
            self.locationRequests.append(completion)
        }

        locationManager.requestLocation()
        return future
    }
}

// MARK: CLLocationManagerDelegate Conformance
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let locationError: LocationError
        if let error = error as? CLError, error.code == .denied {
            locationError = .unauthorized
        } else {
            locationError = .unableToDetermineLocation
        }
        handleLocationRequestResult(.failure(locationError))
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            handleLocationRequestResult(.success(location))
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        while authorizationRequests.count > 0 {
            let request = authorizationRequests.removeFirst()
            request(.success(()))
        }
    }
}
