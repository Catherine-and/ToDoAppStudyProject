//
//  WheatherModel.swift
//  ToDoAppStudyProject
//
//  Created by Ekaterina Isaeva on 04.10.2024.
//

import Foundation

struct Weather: Codable {
    let main: Main
    let name: String
}

struct Main: Codable {
    let temp: Double
}

