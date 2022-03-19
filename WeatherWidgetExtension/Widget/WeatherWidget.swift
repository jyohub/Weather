//
//  WeatherWidget.swift
//  Weather
//
//  Created by jyohub on 2022/03/09.
//

import WidgetKit
import SwiftUI

@main
struct WeatherWidget: Widget {
    private var kind: String = "WeatherWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: WeatherWidgetTimeline(viewModel: WeatherWidgetViewModel())
        ) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Weather Widget")
        .description("This widget displays current weather")
    }
}
