//
//  Response.swift
//  KODE Weather App
//
//  Created by Евгений Урбановский on 17.07.2020.
//  Copyright © 2020 Evgeniy. All rights reserved.
//

import Foundation

struct WindBlock: Decodable {
    var speed: Double
    var deg: Double
}

struct WeatherBlock: Decodable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct MainBlock: Decodable {
    var temp: Double
    var feels_like: Double
    var temp_min: Double
    var temp_max: Double
    var pressure: Int
    var humidity: Int
}

struct Response: Decodable {
    var weather: [WeatherBlock]
    var main: MainBlock
    var wind: WindBlock
}
