//
//  WeatherTimeline.swift
//  Weather
//
//  Created by jyohub on 2022/03/09.
//

import WidgetKit
import SwiftUI
import Combine

class WeatherWidgetTimeline: TimelineProvider {
    private var cancellables = Set<AnyCancellable>()
    
    let viewModel: WeatherWidgetViewModel
    
    init(viewModel: WeatherWidgetViewModel) {
        self.viewModel = viewModel
    }
    
    func placeholder(in context: Context) -> WeatherEntry {
        let weather = Weather(time: Date(), description: "", place: "San Francisco", country: "US", icon: "1d", temperature: 108)
        let entry = WeatherEntry(date: Date(), weather: weather, errorMessage: nil)
        return entry
    }
    
    func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> Void) {
        let weather = Weather(time: Date(), description: "", place: "San Francisco", country: "US", icon: "1d", temperature: 108)
        let entry = WeatherEntry(date: Date(), weather: weather, errorMessage: nil)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<WeatherEntry>) -> Void) {
        viewModel.fetchWeatherData(completion: completion)
    }
}
