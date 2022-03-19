//
//  Weather.swift
//  Weather
//
//  Created by jyohub on 2022/03/09.
//

import Foundation

struct Weather: Decodable, Identifiable {
    var id: TimeInterval { time.timeIntervalSince1970 }
    let time: Date
    let description: String
    let place: String
    let country: String
    let icon: String
    let temperature: Double
    
    enum CodingKeys: String, CodingKey {
        case time = "dt"
        case weather = "weather"
        case description = "description"
        case main = "main"
        case sys = "sys"
        case icon = "icon"
        case id = "id"
        case place = "name"
        case temperature = "temp"
        case country = "country"
    }
    
    init(time: Date, description: String, place: String, country: String, icon: String, temperature: Double) {
        self.time = time
        self.description = description
        self.place = place
        self.country = country
        self.icon = icon
        self.temperature = temperature
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        time = try container.decode(Date.self, forKey: .time)
        place = try container.decode(String.self, forKey: .place)

        var weatherContainer = try container.nestedUnkeyedContainer(forKey: .weather)
        let weather = try weatherContainer.nestedContainer(keyedBy: CodingKeys.self)
        description = try weather.decode(String.self, forKey: .description)
        icon = try weather.decode(String.self, forKey: .icon)
        
        let main = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .main)
        temperature = try main.decode(Double.self, forKey: .temperature)
        
        let sys = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .sys)
        country = try sys.decode(String.self, forKey: .country)
    }
    
    var location: String {
        return "\(place), \(country)"
    }
    
    var weatherIcon: String {
        switch icon {
        case "01d", "01n":
            return "sunny"
        case "02d", "02n":
            return "sunBehindCloud"
        case "03d", "03n":
            return "cloud"
        case "04d", "04n":
            return "cloud"
        case "09d", "09n":
            return "rain"
        case "10d", "10n":
            return "rain"
        case "11d", "11n":
            return "rain"
        case "13d", "13n":
            return "snow"
        case "50d", "50n":
            return "snow"
        default:
            return "cloud"
        }
    }
}
