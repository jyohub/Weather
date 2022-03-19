//
//  WeatherWidgetLarge.swift
//  Weather
//
//  Created by jyohub on 2022/03/07.
//

import SwiftUI

struct WeatherWidgetLarge: View {
    @ObservedObject var viewModel: WeatherWidgetViewModel

    var body: some View {
        if viewModel.isWidgetScreen {
            WeatherWidgetLargeSubview(viewModel: viewModel)
        }
        else {
            WeatherWidgetLargeSubview(viewModel: viewModel)
                .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 24, x: 0, y: 8)
        }
    }
    
    func setEntry(entry: WeatherEntry) {
        self.viewModel.setEntry(entry: entry)
    }
}

struct WeatherWidgetLarge_Previews: PreviewProvider {
    static var previews: some View {
        WeatherWidgetLarge(viewModel: WeatherWidgetViewModel())
    }
}

struct WeatherWidgetLargeSubview: View {
    @ObservedObject var viewModel: WeatherWidgetViewModel
    
    var body: some View {
        ZStack {
            if let errorMessage = viewModel.entry?.errorMessage {
                Text(errorMessage)
                    .padding(16)
                    .font(Font.system(size: 32))
            } else if let image = viewModel.loadImageFromDiskWith(fileName: .backgroundImage) {
                Image(uiImage: image)
                    .resizable()
                VStack(spacing: 42) {
                    Image(viewModel.entry?.weather?.weatherIcon ?? "cloud")
                        .resizable()
                        .frame(width: 155, height: 155)
                    Text(viewModel.entry?.weather?.location ?? "Location")
                        .font(Font.system(size: 32))
                        .foregroundColor(Color.white)
                }
            } else {
                VStack(spacing: 42) {
                    Image(viewModel.entry?.weather?.weatherIcon ?? "cloud")
                        .resizable()
                        .frame(width: 155, height: 155)
                    Text(viewModel.entry?.weather?.location ?? "Location")
                        .font(Font.system(size: 32))
                }
            }
        }
        .frame(width: 329, height: 345)
        .background(Color.white)
        .cornerRadius(22)
    }
    
    func setEntry(entry: WeatherEntry) {
        self.viewModel.setEntry(entry: entry)
    }
}
