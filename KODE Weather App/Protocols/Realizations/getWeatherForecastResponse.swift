//
//  getWeather.swift

import PromiseKit

extension NetworkService: WeatherNetworkService {
    func getWeather(city: String) -> Promise<WeatherForecastResponse> {
        return Promise { seal in
            let params = [
                "q": city,
                "appid": ApiKey.apiKey
            ]
            
            firstly {
                baseRequest(url: URLFactory.baseURL, method: .get, params: params)
            }.done { result in
                seal.fulfill(result)
            }.catch { error in
                print(error)
            }
        }
    }
}
