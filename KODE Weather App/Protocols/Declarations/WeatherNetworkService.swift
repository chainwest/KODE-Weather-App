//
//  WeatherNetworkService.swift

import PromiseKit

protocol WeatherNetworkService {
    func getWeatherForecast(city: String) -> Promise<WeatherForecastResponse>
}
