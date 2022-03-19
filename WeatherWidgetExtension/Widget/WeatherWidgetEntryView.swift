//
//  WeatherWidgetEntryView.swift
//  WeatherWidgetExtension
//
//  Created by jyohub on 2022/03/07.
//

import WidgetKit
import SwiftUI

struct WeatherWidgetEntryView : View {
    var entry: WeatherWidgetTimeline.Entry
    
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            WeatherWidgetSmall(viewModel: WeatherWidgetViewModel(entry: entry, isWidgetScreen: true))
        case .systemMedium:
            WeatherWidgetMedium(viewModel: WeatherWidgetViewModel(entry: entry, isWidgetScreen: true))
        case .systemLarge:
            WeatherWidgetLarge(viewModel: WeatherWidgetViewModel(entry: entry, isWidgetScreen: true))
        default:
            WeatherWidgetSmall(viewModel: WeatherWidgetViewModel(entry: entry, isWidgetScreen: true))
        }
    }
}

