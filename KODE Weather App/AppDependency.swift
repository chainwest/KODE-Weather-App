//
//  AppDependency.swift

import Foundation

protocol HasGeoCodingService {
    var geoCodingService: GeoCodingService { get }
}

protocol HasNetworkService {
    var networkService: NetworkService { get }
}

class AppDependency: HasGeoCodingService, HasNetworkService {
    var geoCodingService: GeoCodingService
    var networkService: NetworkService
    
    init(geoCodingService: GeoCodingService, networkService: NetworkService) {
        self.geoCodingService = geoCodingService
        self.networkService = networkService
    }
    
    static func makeDefault() -> AppDependency {
        let geoCodingService = GeoCodingService()
        let networkService = NetworkService()
        let appDependecy = AppDependency(geoCodingService: geoCodingService, networkService: networkService)
        return appDependecy
    }
}
