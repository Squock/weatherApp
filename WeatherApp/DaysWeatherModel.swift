//
//  DaysWeatherModel.swift
//  WeatherApp
//
//  Created by Admin on 26.01.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct DaysWeatherModel: Codable{
    var list: [DaysWeatherList]
    var city: DaysWeatherCity
}
struct DaysWeatherCity: Codable{
    var timezone: Int
}
struct DaysWeatherList: Codable{
    var main: DaysWeatherMainList
    var dtTxt: String
    var weather: [DaysWeatherArray]
    var clouds: DaysWeatherClouds
    
    enum CodingKeys: String, CodingKey {
        case main = "main"
        case dtTxt = "dt_txt"
        case weather = "weather"
        case clouds = "clouds"
    }
}

struct DaysWeatherMainList: Codable{
    var feelsLike: Double
    var temp: Double
    var tempMax: Double
    var tempMin: Double
    
    enum CodingKeys: String, CodingKey {
        case feelsLike = "feels_like"
        case temp = "temp"
        case tempMax = "temp_max"
        case tempMin = "temp_min"
    }
}
struct DaysWeatherArray: Codable{
    var description: String
    var main: String
}
struct DaysWeatherClouds: Codable{
    var all: Int
}
