//
//  API.swift
//  ToDoAppStudyProject
//
//  Created by Ekaterina Isaeva on 03.10.2024.
//

import Foundation

final class APIManager {
    
    private let apiKey = "3c53048a09eedcf7c46a6acf3205e522"
        
    func load(city: String = "Moscow", completion: @escaping (Result<Weather?, Error>) -> Void) {
        
        guard let url = URL(string:"https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)") else { return }
        
        let session = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error {
                completion(.failure(error))
            } else if let data {
                let weather = try? JSONDecoder().decode(Weather?.self, from: data)
                completion(.success(weather))
            }
        }
        session.resume()
    }
}
