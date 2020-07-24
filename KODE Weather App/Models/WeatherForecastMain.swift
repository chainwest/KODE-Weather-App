//
//  MainBlock.swift
//  KODE Weather App

import Foundation

struct WeatherForecastMain: Decodable {
    var temp: Double
    var feels_like: Double
    var temp_min: Double
    var temp_max: Double
    var pressure: Int
    var humidity: Int
}