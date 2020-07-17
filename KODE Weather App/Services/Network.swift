//
//  Network.swift
//  KODE Weather App

import Alamofire

protocol NetworkDelegate {
    func didRequestWeather(city: String ,completion: @escaping (Swift.Result<Response, Error>) -> Void)
}

class Network {
    private func baseRequest<T>(url: String, method: HTTPMethod, params: Parameters? = nil,
                                completion: @escaping (Swift.Result<T, Error>) -> Void) where T: Decodable {
        AF.request(url, method: method, parameters: params).responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                
                do {
                    let decodedData = try decoder.decode(T.self, from: data)
                    completion(Swift.Result.success(decodedData))
                } catch let error {
                    completion(Swift.Result.failure(error))
                }
            case .failure(let error):
                completion(Swift.Result.failure(error))
            }
        }
    }
}

extension Network: NetworkDelegate {
    func didRequestWeather(city: String, completion: @escaping (Result<Response, Error>) -> Void) {
        let params = [
            "q": city,
            "appid": Constants.APIKey
        ]
        
        baseRequest(url: Constants.url, method: .get, params: params) { response in
            completion(response)
        }
    }
}
