//
//  WeatherViewModel.swift

import PromiseKit
import Alamofire

protocol WeatherViewModelDelegate: class {
    func weatherViewModelDidFinish()
}

class WeatherViewModel {
    typealias Dependency = HasNetworkService
    weak var delegate: WeatherViewModelDelegate?
    let dependencies: Dependency
    
    let cityName: String
    private(set) var temperature = String()
    private(set) var humidity = String()
    private(set) var windSpeed = String()
    private(set) var pressure = String()
    private(set) var weatherDescription = String()
    private(set) var icon = String()
    private(set) var id = Int()
    
    var onDidUpdate: (() -> Void)?
    
    init(dependencies: Dependency, city: String) {
        self.dependencies = dependencies
        self.cityName = city
    }
    
    public func getWeather() {
        firstly {
            dependencies.networkService.getWeatherForecast(city: cityName)
        }.done { (result: WeatherForecastResponse) in
            guard let icon = result.weather.first?.icon else { return }
            guard let id = result.weather.first?.id else { return }
            guard let description = result.weather.first?.description.capitalized else { return }
            guard let direction = self.compassDirection(for: result.wind.deg) else { return }
            let humidity = Int(result.main.humidity)
            let celsium = Int(result.main.temp - 273.15)
            self.icon = icon
            self.id = id
            self.temperature = String(celsium)
            self.humidity = String(humidity) + "%"
            self.windSpeed = direction +  " " + String(result.wind.speed) + " " + "m/s"
            self.pressure = String(result.main.pressure) + " mm Hg"
            self.weatherDescription = description
            self.onDidUpdate?()
        }.catch { error in
            print(error)
        }
    }
    
    private func compassDirection(for heading: Double) -> String? {
        if heading < 0 { return nil }

        let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        let index = Int((heading + 22.5) / 45.0) & 7
        return directions[index]
    }
}
