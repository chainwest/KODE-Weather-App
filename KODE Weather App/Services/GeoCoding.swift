//
//  GeoCoding.swift
//  KODE Weather App

import MapKit

class GeoCoding {
    func cityToCoordinates(city: String, completion: @escaping (Result<CLPlacemark?, Error>) -> Void) {
        CLGeocoder().geocodeAddressString(city) { placemark, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success(placemark?.first))
        }
    }
    
    func coordinatesToCity(coordinate: CLLocationCoordinate2D, completion: @escaping (Result<CLPlacemark?, Error>) -> Void) {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { placemark, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success(placemark?.first))
        }
    }
}
