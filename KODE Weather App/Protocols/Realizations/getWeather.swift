//
//  getWeather.swift

import PromiseKit

extension NetworkService: WeatherNetworkService {
    func getWeather(city: String) -> Promise<Response> {
        return Promise { seal in
            let params = [
                "q": city,
                "appid": ApiKey.APIKey
            ]
            
            firstly {
                baseRequest(url: URLFactory.url, method: .get, params: params)
            }.done { result in
                seal.fulfill(result)
            }.catch { error in
                print(error)
            }
        }
    }
}
