//
//  MapViewController.swift

import UIKit
import MapKit
import SnapKit

class MapViewController: UIViewController {
    let viewModel: MapViewModel
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cardView: CardView!
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap(location: Constants.startCoordinates)
        showCard()
    }
    
    func bindToViewModel() {
        
    }
    
    func setupMap(location: CLLocationCoordinate2D) {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureReconizer:)))
        gestureRecognizer.delegate = self
        let pin = MKPlacemark(coordinate: location)
        let coordinateRegion = MKCoordinateRegion(center: pin.coordinate, latitudinalMeters: 1000000, longitudinalMeters: 1000000)
        
        mapView.addGestureRecognizer(gestureRecognizer)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.addAnnotation(pin)
    }
    
    func showCard() {
        cardView.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.left.equalTo(mapView).offset(20)
            make.bottom.equalTo(mapView).offset(-20)
            make.right.equalTo(mapView).offset(-20)
        }
    }

    func closeCard() {
        UIView.animate(withDuration: 0.2) {
            self.cardView.snp.makeConstraints { make in
                make.bottomMargin.equalTo(self.view.snp.bottom).offset(-200)
            }
            self.view.layoutIfNeeded()
        }
    }
}

extension MapViewController: UIGestureRecognizerDelegate {
  @objc func handleTap(gestureReconizer: UILongPressGestureRecognizer) {
    let location = gestureReconizer.location(in: mapView)
    let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
    viewModel.updateCoordinate(coordinate)
    viewModel.getCity(for: coordinate)
  }
}

extension MapViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    
  }
}
