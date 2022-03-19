//
//  WeatherWidgetMedium.swift
//  Weather
//
//  Created by jyohub on 2022/03/07.
//

import SwiftUI

struct WeatherWidgetMedium: View {
    @ObservedObject var viewModel: WeatherWidgetViewModel
    
    var body: some View {
        if viewModel.isWidgetScreen {
            WeatherWidgetMediumSubview(viewModel: viewModel)
        }
        else {
            WeatherWidgetMediumSubview(viewModel: viewModel)
                .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 24, x: 0, y: 8)
        }
    }
    
    func setEntry(entry: WeatherEntry) {
        self.viewModel.setEntry(entry: entry)
    }
}

struct WeatherWidgetMedium_Previews: PreviewProvider {
    static var previews: some View {
        WeatherWidgetMedium(viewModel: WeatherWidgetViewModel())
    }
}

struct WeatherWidgetMediumSubview: View {
    @ObservedObject var viewModel: WeatherWidgetViewModel
    
    var body: some View {
        ZStack {
            if let errorMessage = viewModel.entry?.errorMessage {
                Text(errorMessage)
                    .font(Font.system(size: 24))
            } else if let image = viewModel.loadImageFromDiskWith(fileName: .backgroundImage) {
                Image(uiImage: image)
                    .resizable()
                HStack {
                    VStack(alignment: .leading) {
                        Image(viewModel.entry?.weather?.weatherIcon ?? "cloud")
                            .resizable()
                            .frame(width: 82, height: 82)
                        Text(viewModel.entry?.weather?.location ?? "Location")
                            .font(Font.system(size: 24))
                            .foregroundColor(Color.white)
                    }
                    Spacer()
                }.padding(.leading, 16)
            } else {
                HStack {
                    VStack(alignment: .leading) {
                        Image(viewModel.entry?.weather?.weatherIcon ?? "cloud")
                            .resizable()
                            .frame(width: 82, height: 82)
                        Text(viewModel.entry?.weather?.location ?? "Location")
                            .font(Font.system(size: 24))
                    }
                    Spacer()
                }.padding(.leading, 16)
            }
        }
        .frame(width: 329, height: 155)
        .background(Color.white)
        .cornerRadius(22)
    }
    
    func setEntry(entry: WeatherEntry) {
        self.viewModel.setEntry(entry: entry)
    }
}
