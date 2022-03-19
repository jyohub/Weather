//
//  WeatherViewController.swift
//  Weather
//
//  Created by jyohub on 2022/03/07.
//

import UIKit
import SwiftUI
import CoreLocation
import Combine

class WeatherViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
        
    private let imagePickerController: UIImagePickerController = UIImagePickerController()
    private let activityIndicatorManager = ActivityIndicatorManager()
    private var cancellables = Set<AnyCancellable>()

    var viewModel: WeatherViewModelProtocol?
    var currentWeather: Weather?
    var errorMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.fetchLocation()
    }
    
    @IBAction func changeBackground(_ pageControl: UIPageControl) {
        self.present(imagePickerController, animated: true)
    }
}

// MARK: Setup UI
extension WeatherViewController {
    
    private func setupUI() {
        self.title = .navigationBarTitle
        activityIndicatorManager.view = view
        registerCells()
        setupImagePicker()
    }
    
    private func registerCells() {
        collectionView.register(cell: WeatherWidgetSmallCollectionViewCell.self)
        collectionView.register(cell: WeatherWidgetMediumCollectionViewCell.self)
        collectionView.register(cell: WeatherWidgetLargeCollectionViewCell.self)
    }
    
    private func setupImagePicker() {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
    }
    
    private func displayErorMessage(errorMessage: String?) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: Binding
extension WeatherViewController {

    private func bind() {
        bindLocationFetchState()
        bindCurrentWeatherFetch()
        bindErrorMessage()
        bindForApplicationDidBecomeActiveNotification()
    }
    
    private func bindLocationFetchState() {
        viewModel?.locationFetchState.sink { [weak self] state in
            switch state {
            case .isLoading:
                self?.activityIndicatorManager.showActivityIndicator()
            case .failed(let error):
                self?.activityIndicatorManager.hideActivityIndicator()
                self?.errorMessage = error.errorDescription
                switch error {
                case .unauthorized:
                    self?.displayErorMessage(errorMessage: error.errorDescription)
                case .unableToDetermineLocation:
                    self?.displayErorMessage(errorMessage: error.errorDescription)
                }
                self?.collectionView.reloadData()
            case .loaded(let location):
                self?.viewModel?.fetchWeatherData(location: location)
            }
        }.store(in: &cancellables)
    }
    
    private func bindCurrentWeatherFetch() {
        viewModel?.currentWeather.sink { [weak self] currentWeather in
            self?.currentWeather = currentWeather
            self?.activityIndicatorManager.hideActivityIndicator()
            self?.collectionView.reloadData()
        }.store(in: &cancellables)
    }
    
    private func bindErrorMessage() {
        viewModel?.errorMessage.sink { [weak self] errorMessage in
            self?.errorMessage = errorMessage
            self?.activityIndicatorManager.hideActivityIndicator()
            self?.displayErorMessage(errorMessage: errorMessage)
            self?.collectionView.reloadData()
        }.store(in: &cancellables)
    }
    
    private func bindForApplicationDidBecomeActiveNotification() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(applicationDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil)
    }
    
    @objc private func applicationDidBecomeActive() {
        viewModel?.fetchLocation()
    }
}

// MARK: ImagePickerControllerDelegate
extension WeatherViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            FileManager.default.saveBackgroundImageToDocumentDirectory(image: image)
        }
        self.dismiss(animated: true, completion: nil)
        self.collectionView.reloadData()
    }
}




