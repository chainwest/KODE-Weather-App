//
//  Response.swift

import Foundation

struct WeatherForecastResponse: Decodable {
    var weather: [WeatherForecastProperties]
    var main: WeatherForecastMain
    var wind: WeatherForecastWind
}
