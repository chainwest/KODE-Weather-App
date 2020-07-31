//
//  WeatherViewModel.swift

import PromiseKit
import Alamofire

protocol WeatherViewModelDelegate: class {
    func viewModelDidFinish()
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
    
    var onDidUpdate: (() -> Void)?
    
    init(dependencies: Dependency, city: String) {
        self.dependencies = dependencies
        self.cityName = city
    }
    
    func getWeather() {
        firstly {
            dependencies.networkService.getWeatherForecast(city: cityName)
        }.done { (result: WeatherForecastResponse) in
            let celsium = Int(result.main.temp - 273.15)
            self.temperature = String(celsium)
            self.humidity = String(result.main.humidity) + "%"
            self.windSpeed = String(result.wind.speed)
            self.pressure = String(result.main.pressure) + " mm Hg"
            self.weatherDescription = String(result.weather.description)
            if result.weather.first?.icon != nil {
                self.icon = result.weather.first!.icon
            }
            self.onDidUpdate?()
        }.catch { error in
            print(error)
        }
    }
}
