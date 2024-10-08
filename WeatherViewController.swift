    //
    //  WeatherViewController.swift
    //  ToDoAppStudyProject
    //
    //  Created by Ekaterina Isaeva on 03.10.2024.
    //

    import UIKit
    import CoreLocation

    class WeatherViewController: UIViewController {
        
        // MARK: - GUE variable
        
        let locationManager =  CLLocationManager()
        
        private lazy var tempLabel: UILabel = {
            let label = UILabel()
            
            label.text = "--"
            label.font = UIFont.systemFont(ofSize: 90, weight: .light)
            label.textColor = .blue
            
            return label
        }()
        
        
        private lazy var cityLabel: UILabel = {
            let label = UILabel()
            
            label.text = "My location"
            label.font = .boldSystemFont(ofSize: 24)
            label.textColor = .black
            
            return label
        }()
        
        // MARK: - Life circle
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.addSubview(tempLabel)
            view.addSubview(cityLabel)
            
            setupConstraints()
            
            tempLabel.translatesAutoresizingMaskIntoConstraints = false
            cityLabel.translatesAutoresizingMaskIntoConstraints = false
            
            startLocationManager()
        }
        
        // MARK: - Constraints

        func setupConstraints() {
            NSLayoutConstraint.activate([
                tempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                tempLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                
                cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                cityLabel.bottomAnchor.constraint(equalTo: tempLabel.topAnchor, constant: -16)
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
