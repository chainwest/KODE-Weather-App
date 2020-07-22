//
//  MainBlock.swift
//  KODE Weather App
//
//  Created by Евгений Урбановский on 21.07.2020.
//  Copyright © 2020 Evgeniy. All rights reserved.
//

import Foundation

struct MainBlock: Decodable {
    var temp: Double
    var feels_like: Double
    var temp_min: Double
    var temp_max: Double
    var pressure: Int
    var humidity: Int
}
