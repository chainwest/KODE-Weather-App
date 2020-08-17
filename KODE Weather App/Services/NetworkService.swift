//
//  NetworkService.swift

import Alamofire
import PromiseKit

enum ApiErrors: Error {
  case badCityError
  case serverError
}

extension ApiErrors: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .badCityError:
      return "Couldn't get weather for city"
    case .serverError:
      return "There is some server error, try again later"
    }
    }
}

class NetworkService {
    public func baseRequest<T: Decodable>(url: String, method: HTTPMethod, params: Parameters? = nil) -> Promise<T> {
        return Promise { seal in
            AF.request(url, method: method, parameters: params).responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(T.self, from: data)
                    seal.fulfill(decodedData)
                } catch {
                    seal.reject(ApiErrors.badCityError)
                }
            case .failure:
                seal.reject(ApiErrors.serverError)
            }
        }
    }
    }
}
