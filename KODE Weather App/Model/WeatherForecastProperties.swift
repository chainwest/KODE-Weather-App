//
//  WeatherBlock.swift


import Foundation

struct WeatherForecastProperties: Decodable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}
