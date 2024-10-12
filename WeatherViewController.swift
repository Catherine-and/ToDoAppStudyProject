//
//  WeatherViewController.swift
//  ToDoAppStudyProject
//
//  Created by Ekaterina Isaeva on 03.10.2024.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    let locationManager =  CLLocationManager()
    
    // MARK: - GUE variable
    
    private lazy var tempLabel: UILabel = {
        let label = UILabel()
        
        label.text = "--"
        label.font = UIFont.systemFont(ofSize: 100, weight: .light)
        label.textColor = .deepViolet
        
        return label
    }()
    
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        
        label.text = "My location"
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var skyLabel: UILabel = {
        let label = UILabel()
        
        label.text = "--"
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private lazy var skyDesctiptionLabel: UILabel = {
        let label = UILabel()
        
        label.text = "--"
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [skyLabel,
                                                  skyDesctiptionLabel])
        
        view.axis = .horizontal
        view.spacing = 10
        view .alignment = .center
        view.distribution = .equalSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    // MARK: - Life circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightBlue
        
        view.addSubview(tempLabel)
        view.addSubview(cityLabel)
        
        addSubviews()
        
        setupConstraints()
        
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        startLocationManager()
    }
    
    private func addSubviews() {
        view.addSubview(stackView)
    }
    
    // MARK: - Constraints
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tempLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityLabel.bottomAnchor.constraint(equalTo: tempLabel.topAnchor, constant: -16),
            
            stackView.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 16),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Work with location
    
    func startLocationManager() {
        
        locationManager.requestWhenInUseAuthorization()
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
                self.locationManager.pausesLocationUpdatesAutomatically = false
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
}

// MARK: - Work with CLLocationManagerDelegate
// MARK: - Call APIManager

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            
            APIManager().load(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let weather):
                        if let weather {
                            let tempInCelsius = Int((weather.main.temp) - 273.15)
                            self?.tempLabel.text = String(tempInCelsius) + "º"
                            self?.cityLabel.text = weather.name
                            let weatherDescrioption = weather.weather.first?.main
                            self?.skyLabel.text = weatherDescrioption
                            let skyConditions = weather.weather.last?.description
                            self?.skyDesctiptionLabel.text = "(" + skyConditions! + ")"
                        } else {
                            self?.show(error: nil)
                        }
                    case .failure(let error):
                        self?.show(error: error)
                    }
                }
            }
        }
    }
    
    private func show(error: Error?) {
        let message = error == nil ? "Data is empty" : error?.localizedDescription
        
        let controller = UIAlertController(title: "Error",
                                           message: message,
                                           preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(controller, animated: true)
    }
}
