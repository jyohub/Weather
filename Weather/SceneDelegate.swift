//
//  SceneDelegate.swift
//  Weather
//
//  Created by jyohub on 2022/03/07.
//

import UIKit
import WidgetKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let weatherViewController = storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController else {
            fatalError("WeatherViewController not instantiated")
        }
        weatherViewController.viewModel = WeatherViewModel(weatherService: WeatherService(),
                                                           locationManager: LocationManager())
        window.rootViewController = UINavigationController(rootViewController: weatherViewController)
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        WidgetCenter.shared.reloadAllTimelines()
    }

}

