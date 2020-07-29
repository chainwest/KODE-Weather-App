//
//  MapViewModel.swift

import MapKit
import PromiseKit

protocol MapViewModelDelegate: class {
    func mapViewModel(_ viewModel: MapViewModel, didRequestShowWeatherFor city: String)
}

class MapViewModel {
    typealias Dependency = HasGeoCodingService
    weak var delegate: MapViewModelDelegate?
    let dependencies: Dependency
    
    var cardIsOpened = false
    private(set) var selectedCity: String?
    private(set) var selectedCoordinates: CLLocationCoordinate2D?
    
    var onDidUpdate: (() -> Void)?
    
    init(dependencies: Dependency) {
        self.dependencies = dependencies
    }
    
    func getCoordinates(for city: String) {
        firstly {
            dependencies.geoCodingService.cityToCoordinates(city: city)
        }.done { result in
            self.selectedCoordinates = result.location?.coordinate
            self.onDidUpdate?()
        }.catch { error in
            print(error)
        }
    }
    
    func getCity(for coordinates: CLLocationCoordinate2D) {
        firstly {
            dependencies.geoCodingService.coordinatesToCity(coordinate: coordinates)
        }.done { result in
            self.selectedCity = result.locality
            self.delegate?.mapViewModel(self, didRequestShowWeatherFor: result.locality ?? "-")
        }.catch { error in
            print(error)
        }
    }
    
    func updateCoordinate(_ coordinate: CLLocationCoordinate2D) {
        selectedCoordinates = coordinate
    }
}

extension MapViewModel: CardViewModelDelegate {
    func cardViewModelDidTapClose(_ viewModel: CardViewModel) {
        cardIsOpened = false
    }
    
    func cardViewModelDidTapShowWeather(_ viewModel: CardViewModel) {
        guard let coordinates = selectedCoordinates else { return }
        getCity(for: coordinates)
    }
}
