//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Admin on 24.01.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct WeatherModel: Codable{
    var weather: [WeatherArray]
    var name: String
    var main: MainList
}

struct WeatherArray: Codable{
    var description: String
    var main: String
}

struct MainList: Codable{
    var temp: Double
    var tempMax: Double
    var tempMin: Double
    var feelsLike: Double
    
    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case tempMax = "temp_max"
        case tempMin = "temp_min"
        case feelsLike = "feels_like"
    }

}

protocol MapViewControllerDelegate{
    func weather(description: String, main: String, city: String, temp: Double, tempMax: Double, tempMin: Double, feelsLike: Double)
}
