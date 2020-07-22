//
//  GeoCoding.swift
//  KODE Weather App

import MapKit
import PromiseKit

class GeoCodingService {
    func cityToCoordinates(city: String) -> Promise<CLPlacemark> {
        return Promise { seal in
            CLGeocoder().geocodeAddressString(city) { placemark, error in
                if let error = error {
                    seal.reject(error)
                    return
                }
                seal.fulfill((placemark?.first)!)
            }
        }
    }
    
    func coordinatesToCity(coordinate: CLLocationCoordinate2D) -> Promise<CLPlacemark> {
        return Promise { seal in
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { placemark, error in
                if let error = error {
                    seal.reject(error)
                    return
                }
                seal.fulfill((placemark?.first)!)
            }
        }
    }
}
