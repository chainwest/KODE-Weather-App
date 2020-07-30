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
    private(set) var selectedCoordinatesString: String?
    
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
            self.onDidUpdate?()
        }.catch { error in
            print(error)
        }
    }
    
    func updateCoordinate(_ coordinate: CLLocationCoordinate2D) {
        selectedCoordinates = coordinate
        coordinatesToString()
    }
    
    func coordinatesToString() {
        guard let latitude: String = selectedCoordinates?.latitude.description else { return }
        guard let longitude: String = selectedCoordinates?.longitude.description else { return }
        selectedCoordinatesString = latitude + " " + longitude
    }
}

extension MapViewModel: CardViewModelDelegate {
    func cardViewModelDidTapClose(_ viewModel: CardViewModel) {
        viewModel.cardIsOpened = false
    }
    
    func cardViewModelDidTapShowWeather(_ viewModel: CardViewModel) {
        guard let city = selectedCity else { return }
        delegate?.mapViewModel(self, didRequestShowWeatherFor: city)
    }
}
