//
//  GeoCoding.swift
//  KODE Weather App

import MapKit
import PromiseKit

struct GeoCodingService {
    private let geocoder = CLGeocoder()
    
    func cityToCoordinates(city: String) -> Promise<CLPlacemark> {
        return Promise { seal in
            geocoder.geocodeAddressString(city) { placemark, error in
                if let error = error {
                    seal.reject(error)
                    return
                }
                
                if let firstPlacemark = placemark?.first {
                    seal.fulfill(firstPlacemark)
                }
            }
        }
    }
    
    func coordinatesToCity(coordinate: CLLocationCoordinate2D) -> Promise<CLPlacemark> {
        return Promise { seal in
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            geocoder.reverseGeocodeLocation(location) { placemark, error in
                if let error = error {
                    seal.reject(error)
                    return
                }
                
                if let firstPlacemark = placemark?.first {
                    seal.fulfill(firstPlacemark)
                }
            }
        }
    }
}
