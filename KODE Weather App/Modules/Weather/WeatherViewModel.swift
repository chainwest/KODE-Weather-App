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
            let celsium = Int(result.main.temp - 273.15)
            self.icon = icon
            self.id = id
            self.temperature = String(celsium)
            self.humidity = String(result.main.humidity) + "%"
            self.windSpeed = String(result.wind.speed)
            self.pressure = String(result.main.pressure) + " mm Hg"
            self.weatherDescription = String(result.weather.description)
            self.onDidUpdate?()
        }.catch { error in
            print(error)
        }
    }
}
