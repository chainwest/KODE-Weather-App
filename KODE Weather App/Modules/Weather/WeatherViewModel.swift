//
//  WeatherViewModel.swift

import PromiseKit
import Alamofire
import SVProgressHUD

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
    private(set) var weatherState = String()
    private(set) var error = String()
    
    var onDidUpdate: (() -> Void)?
    var onDidError: (() -> Void)?
    
    init(dependencies: Dependency, city: String) {
        self.dependencies = dependencies
        self.cityName = city
    }
    
    public func getWeather() {
        SVProgressHUD.show()
        firstly {
            dependencies.networkService.getWeatherForecast(city: cityName)
        }.done { (result: WeatherForecastResponse) in
            SVProgressHUD.dismiss()
            guard let icon = result.weather.first?.icon else { return }
            guard let description = result.weather.first?.description.capitalized else { return }
            guard let direction = self.compassDirection(for: result.wind.deg) else { return }
            guard let weatherState = result.weather.first?.main else { return }
            let humidity = Int(result.main.humidity)
            let celsium = Int(result.main.temp - 273.15)
            self.icon = icon
            self.temperature = String(celsium)
            self.weatherState = weatherState
            self.humidity = String(humidity) + "%"
            self.windSpeed = direction +  " " + String(result.wind.speed) + " " + "m/s"
            self.pressure = String(result.main.pressure) + " mm Hg"
            self.weatherDescription = description
            self.onDidUpdate?()
        }.catch { error in
            self.error = error.localizedDescription
            self.onDidError?()
        }
    }
    
    private func compassDirection(for heading: Double) -> String? {
        if heading < 0 { return nil }

        let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        let index = Int((heading + 22.5) / 45.0) & 7
        return directions[index]
    }
}
