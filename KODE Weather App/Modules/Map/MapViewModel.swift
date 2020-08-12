//
//  MapViewModel.swift

import MapKit
import PromiseKit
import SVProgressHUD

protocol MapViewModelDelegate: class {
    func mapViewModel(_ viewModel: MapViewModel, didRequestShowWeatherFor city: String)
}

class MapViewModel {
    typealias Dependency = HasGeoCodingService
    weak var delegate: MapViewModelDelegate?
    let dependencies: Dependency
    
    var selectedCity: String?
    private(set) var selectedCoordinates: CLLocationCoordinate2D?
    private(set) var selectedCoordinatesString: String?
    private(set) var error = ""
    
    var onDidUpdate: (() -> Void)?
    var onDidError: (() -> Void)?
    
    init(dependencies: Dependency) {
        self.dependencies = dependencies
    }
    
    public func getCoordinates(for city: String) {
        SVProgressHUD.show()
        firstly {
            dependencies.geoCodingService.cityToCoordinates(city: city)
        }.done { result in
            SVProgressHUD.dismiss()
            self.selectedCoordinates = result.location?.coordinate
            self.coordinatesToString()
            self.onDidUpdate?()
        }.catch { error in
            self.error = error.localizedDescription
            self.onDidError?()
        }
    }
    
    public func getCity(for coordinates: CLLocationCoordinate2D) {
        SVProgressHUD.show()
        firstly {
            dependencies.geoCodingService.coordinatesToCity(coordinate: coordinates)
        }.done { result in
            SVProgressHUD.dismiss()
            self.selectedCity = result.locality
            self.onDidUpdate?()
        }.catch { error in
            self.error = error.localizedDescription
            self.onDidError?()
        }
    }
    
    public func updateCoordinate(_ coordinate: CLLocationCoordinate2D) {
        selectedCoordinates = coordinate
        coordinatesToString()
    }
    
    public func coordinatesToString() {
        selectedCoordinatesString = selectedCoordinates?.convertCoordinate
    }
}
