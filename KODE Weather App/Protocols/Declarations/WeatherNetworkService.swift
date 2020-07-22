//
//  WeatherNetworkService.swift

import PromiseKit

protocol WeatherNetworkService {
    func getWeather(city: String) -> Promise<Response>
}
