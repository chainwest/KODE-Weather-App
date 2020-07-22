//
//  NetworkService.swift

import Alamofire
import PromiseKit

class NetworkService {
    public func baseRequest(url: String, method: HTTPMethod, params: Parameters? = nil) -> Promise<Response> {
        return Promise { seal in
            AF.request(url, method: method, parameters: params).responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                
                do {
                    let decodedData = try decoder.decode(Response.self, from: data)
                    seal.fulfill(decodedData)
                } catch let error {
                    seal.reject(error)
                }
            case .failure(let error):
                seal.reject(error)
            }
        }
    }
    }
}
