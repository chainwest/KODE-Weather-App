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
        bindToViewModel()
        setupMap(location: Constants.startCoordinates)
        setupSearchBar(self)
        setupCardView()
    }
    
    func bindToViewModel() {
        viewModel.onDidUpdate = { [weak self] in
            guard let cityName = self?.viewModel.selectedCity else {
                self?.closeCard()
                return
            }
            self?.cardView.coordinatesLabel.text = self?.viewModel.selectedCoordinatesString
            self?.cardView.cityLabel.text = cityName
            
            guard let isOpened = self?.cardView.viewModel!.cardIsOpened else { return }
            if isOpened {
                self?.closeCard()
            } else {
                self?.showCard()
            }
        }
    }
    
    func setupSearchBar(_ viewController: UIViewController) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        viewController.navigationItem.searchController = searchController
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
    
    func setupCardView() {
        let cardViewModel = CardViewModel(delegate: viewModel)
        cardView.setupCardView(with: cardViewModel)
    }
    
    func showCard() {
        UIView.animate(withDuration: 0.2) {
            self.cardView.snp.makeConstraints { make in
                make.height.equalTo(150)
                make.left.equalTo(self.mapView).offset(20)
                make.bottom.equalTo(self.mapView).offset(-20)
                make.right.equalTo(self.mapView).offset(-20)
            }
            self.view.layoutIfNeeded()
        }
    }

    func closeCard() {
        UIView.animate(withDuration: 0.2) {
            self.cardView.snp.makeConstraints { make in
                make.height.equalTo(150)
                make.left.equalTo(self.mapView).offset(20)
                make.bottom.equalTo(self.mapView).offset(220)
                make.right.equalTo(self.mapView).offset(-20)
            }
            self.view.layoutIfNeeded()
        }
    }
}

extension MapViewController: UIGestureRecognizerDelegate {
  @objc func handleTap(gestureReconizer: UILongPressGestureRecognizer) {
    let location = gestureReconizer.location(in: mapView)
    let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
    let pin = MKPlacemark(coordinate: coordinate)
    mapView.removeAnnotations(mapView.annotations)
    mapView.addAnnotation(pin)
    viewModel.updateCoordinate(coordinate)
    viewModel.getCity(for: coordinate)
  }
}

extension MapViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text else { return }
    guard !text.isEmpty else { return }
    viewModel.getCoordinates(for: text)
    viewModel.onDidUpdate = { [weak self] in
        guard let selectedCoordinate = self?.viewModel.selectedCoordinates else { return }
        self?.viewModel.getCity(for: selectedCoordinate)
        let pin = MKPlacemark(coordinate: selectedCoordinate)
        self?.mapView.removeAnnotations((self?.mapView.annotations)!)
        self?.mapView.addAnnotation(pin)
        self?.mapView.setCenter(selectedCoordinate, animated: true)
    }
  }
}
