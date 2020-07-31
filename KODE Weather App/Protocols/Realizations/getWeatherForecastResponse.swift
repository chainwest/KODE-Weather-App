//
//  getWeather.swift

import PromiseKit
import Alamofire

extension NetworkService: WeatherNetworkService {
    func getWeatherForecast(city: String) -> Promise<WeatherForecastResponse> {
        let params = [
            "q": city,
            "appid": ApiKey.apiKey
        ]
        return baseRequest(url: URLFactory.baseURL + "/data/2.5/weather", method: .get, params: params)
    }
}
