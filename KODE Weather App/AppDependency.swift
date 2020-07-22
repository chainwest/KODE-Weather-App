//
//  AppDependency.swift

import Foundation

protocol HasGeoCodingService {
    var geoCodingService: GeoCodingService { get }
}

class AppDependency: HasGeoCodingService {
    var geoCodingService: GeoCodingService
    
    init(geoCodingService: GeoCodingService) {
        self.geoCodingService = geoCodingService
    }
    
    static func makeDefault() -> AppDependency {
        let geoCodingService = GeoCodingService()
        let appDependecy = AppDependency(geoCodingService: geoCodingService)
        return appDependecy
    }
}
