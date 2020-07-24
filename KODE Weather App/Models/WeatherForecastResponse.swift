//
//  Response.swift

import Foundation

struct WeatherForecastResponse: Decodable {
    var weather: [WeatherForecastWind]
    var main: WeatherForecastProperties
    var wind: WeatherForecastMain
}
