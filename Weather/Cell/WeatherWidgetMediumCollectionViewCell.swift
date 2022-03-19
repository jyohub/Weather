//
//  WeatherWidgetMediumCollectionViewCell.swift
//  Weather
//
//  Created by jyohub on 2022/03/10.
//

import UIKit
import SwiftUI

class WeatherWidgetMediumCollectionViewCell: UICollectionViewCell {
    
    var weatherWidgetType: WeatherWidgetType = .medium
    var weatherWidgetMedium = WeatherWidgetMedium(viewModel: WeatherWidgetViewModel(isWidgetScreen: false))

    lazy var host: UIHostingController<WeatherWidgetMedium> = {
        return UIHostingController(rootView: weatherWidgetMedium)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        host.view.translatesAutoresizingMaskIntoConstraints = false
        host.view.backgroundColor = .clear
        contentView.addSubview(host.view)
        
        NSLayoutConstraint.activate([
            host.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            host.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            host.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func setCurrentWeather(weather: Weather?, errorMessage: String?) {
        weatherWidgetMedium.setEntry(entry: WeatherEntry(date: Date(), weather: weather, errorMessage: errorMessage))
    }
}
