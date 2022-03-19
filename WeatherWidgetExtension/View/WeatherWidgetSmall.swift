//
//  WeatherWidgetSmall.swift
//  Weather
//
//  Created by jyohub on 2022/03/07.
//

import SwiftUI
import Combine
import CoreLocation

struct WeatherWidgetSmall: View {
    @ObservedObject var viewModel: WeatherWidgetViewModel
    
    var body: some View {
        if viewModel.isWidgetScreen {
            WeatherWidgetSmallSubview(viewModel: viewModel)
        }
        else {
            WeatherWidgetSmallSubview(viewModel: viewModel)
                .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 24, x: 0, y: 8)
        }
    }
    
    func setEntry(entry: WeatherEntry) {
        self.viewModel.setEntry(entry: entry)
    }
}

struct WeatherWidgetSmall_Previews: PreviewProvider {
    static var previews: some View {
        WeatherWidgetSmall(viewModel: WeatherWidgetViewModel())
    }
}

struct WeatherWidgetSmallSubview: View {
    @ObservedObject var viewModel: WeatherWidgetViewModel
    
    var body: some View {
        ZStack {
            if let errorMessage = viewModel.entry?.errorMessage {
                Text(errorMessage)
                    .font(Font.system(size: 18))
            } else if let image = viewModel.loadImageFromDiskWith(fileName: .backgroundImage) {
                Image(uiImage: image)
                    .resizable()
                VStack {
                    Image(viewModel.entry?.weather?.weatherIcon ?? "cloud")
                        .resizable()
                        .frame(width: 67, height: 67)
                    Text(viewModel.entry?.weather?.location ?? "Location")
                        .font(Font.system(size: 18))
                        .foregroundColor(.white)
                }
            } else {
                VStack {
                    Image(viewModel.entry?.weather?.weatherIcon ?? "cloud")
                        .resizable()
                        .frame(width: 67, height: 67)
                    Text(viewModel.entry?.weather?.location ?? "Location")
                        .font(Font.system(size: 18))
                }
            }
        }
        .frame(width: 155, height: 155)
        .background(Color.white)
        .cornerRadius(22)
    }
    
    func setEntry(entry: WeatherEntry) {
        self.viewModel.setEntry(entry: entry)
    }
}
