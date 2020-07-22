//
//  WeatherBlock.swift

import Foundation

struct WeatherBlock: Decodable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}
