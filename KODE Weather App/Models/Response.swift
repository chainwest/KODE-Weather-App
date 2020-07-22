//
//  Response.swift

import Foundation

struct Response: Decodable {
    var weather: [WeatherBlock]
    var main: MainBlock
    var wind: WindBlock
}
