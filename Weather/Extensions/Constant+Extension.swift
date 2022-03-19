//
//  Constant+Extension.swift
//  Weather
//
//  Created by jyohub on 2022/03/12.
//

import Foundation

extension String {
    public static let navigationBarTitle = "Weather Widget"
    public static let backgroundImage = "backgroundImage.jpeg"
    
    public static let urlInvalid = "URL invalid"
}

extension Notification.Name {
    static let imageSaved = Notification.Name("imageSaved")
    static let weatherUpdated = Notification.Name("weatherUpdated")
}
