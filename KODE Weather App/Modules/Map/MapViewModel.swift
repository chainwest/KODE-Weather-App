//
//  MapViewModel.swift

import MapKit
import PromiseKit

protocol MapViewModelDelegate: class {
    func mapViewModel(_ viewModel: MapViewModel, didRequestShowWeatherFor city: String)
}

class MapViewModel {
    typealias Dependencies = HasGeoCodingService
    weak var delegate: MapViewModelDelegate?
    let dependencies: Dependencies
    
    private(set) var selectedCoordinates: CLLocationCoordinate2D?
    private(set) var selectedCity: String?
    
    var onDidUpdate: (() -> Void)?
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func coordinatesToCity(coordinates: CLLocationCoordinate2D) {
        firstly {
            dependencies.geoCodingService.coordinatesToCity(coordinate: coordinates)
        }.done { result in
            self.selectedCity = result.locality!
            self.onDidUpdate?()
        }.catch { error in
            print(error)
        }
    }
    
    func cityToCoordinates(city: String) {
        firstly {
            dependencies.geoCodingService.cityToCoordinates(city: city)
        }.done { result in
            self.selectedCoordinates = result.location?.coordinate
            self.onDidUpdate?()
        }.catch { error in
            print(error)
        }
    }
    
    func updateCoordinates(coordinates: CLLocationCoordinate2D) {
        self.selectedCoordinates = coordinates
    }
    
    func goToWeatherScreen() {
        guard let city = selectedCity else { return }
        delegate?.mapViewModel(self, didRequestShowWeatherFor: city)
    }
}
