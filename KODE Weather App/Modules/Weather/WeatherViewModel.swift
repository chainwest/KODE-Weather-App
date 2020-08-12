//
//  WeatherViewModel.swift

import PromiseKit
import Alamofire
import SVProgressHUD

protocol WeatherViewModelDelegate: class {
    func weatherViewModelDidFinish(_ viewModel: WeatherViewModel)
}

class WeatherViewModel {
    typealias Dependency = HasNetworkService
    weak var delegate: WeatherViewModelDelegate?
    let dependencies: Dependency
    var weatherState: WeatherState
    
    let cityName: String
    private(set) var error = ""
    
    var onDidUpdate: (() -> Void)?
    var onDidError: (() -> Void)?
    
    init(dependencies: Dependency, city: String) {
        self.dependencies = dependencies
        self.cityName = city
        self.weatherState = WeatherState()
    }
    
    public func getWeather() {
        SVProgressHUD.show()
        firstly {
            dependencies.networkService.getWeatherForecast(city: cityName)
        }.done { (result: WeatherForecastResponse) in
            SVProgressHUD.dismiss()
            self.updateData(result)
            self.onDidUpdate?()
        }.catch { error in
            self.error = error.localizedDescription
            self.onDidError?()
        }
    }
    
    private func updateData(_ response: WeatherForecastResponse) {
        let direction = compassDirection(for: response.wind.deg)
        weatherState.temperature = String(Int(response.main.temp - 273.15))
        weatherState.humidity = String(Int(response.main.humidity)) + "%"
        weatherState.windSpeed = direction + " " + String(response.wind.speed) + " m/s"
        weatherState.pressure = String(response.main.pressure) + " mm Hg"
        weatherState.description = response.weather.first?.description.capitalized ?? "Sunny"
        weatherState.icon = response.weather.first?.icon ?? "01n"
        weatherState.state = response.weather.first?.main ?? "Mist"
    }
    
    private func compassDirection(for heading: Double) -> String {
        if heading < 0 { return "Wind direction error" }
        let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        let index = Int((heading + 22.5) / 45.0) & 7
        return directions[index]
    }
}
