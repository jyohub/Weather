//
//  WeatherEntry.swift
//  Weather
//
//  Created by jyohub on 2022/03/09.
//

import WidgetKit
import SwiftUI

struct WeatherEntry: TimelineEntry {
    public let date: Date
    public let weather: Weather?
    public let errorMessage: String?
     
    var relevance: TimelineEntryRelevance? {
        return TimelineEntryRelevance(score: 50)
    }
}
