//
//  MapViewController.swift

import UIKit
import MapKit
import SnapKit
import SVProgressHUD

class MapViewController: UIViewController {
    private let viewModel: MapViewModel
    private let cardView: CardView
    private var keyboardIsOpened = false
    
    @IBOutlet private weak var mapView: MKMapView!
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        self.cardView = CardView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotificationCenter()
        bindToViewModel()
        setupMap(location: Constants.startCoordinates)
        setupSearchBar(self)
        setupCardView()
    }
    
    private func bindToViewModel() {
        viewModel.onDidUpdate = { [weak self] in
            guard let self = self else { return }
            guard let cityName = self.viewModel.selectedCity else {
                self.closeCard()
                return
            }
            guard let selectedCoordinates = self.viewModel.selectedCoordinates else { return }
            let pin = MKPlacemark(coordinate: selectedCoordinates)
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotation(pin)
            self.mapView.setCenter(selectedCoordinates, animated: true)
            self.viewModel.updateCoordinate(selectedCoordinates)
            guard let cityCoordinatesString = self.viewModel.selectedCoordinatesString else { return }
            self.cardView.setCityAndCoordinates(cityName, cityCoordinatesString)
            if self.keyboardIsOpened {
                self.showCardOnCenterOfScreen()
            } else {
                self.showCard()
            }
        }
        
        viewModel.onDidError = { [weak self] in
            guard let error = self?.viewModel.error else { return }
            self?.showError(error)
        }
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func setupSearchBar(_ viewController: UIViewController) {
        let searchController = UISearchController(searchResultsController: nil)
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        viewController.navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.backgroundColor = .white
        searchController.searchBar.isTranslucent = false
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Map", style: .plain, target: nil, action: nil)
        navigationItem.title = "Global Weather"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .systemBlue
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupMap(location: CLLocationCoordinate2D) {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureReconizer:)))
        gestureRecognizer.delegate = self
        let pin = MKPlacemark(coordinate: location)
        let coordinateRegion = MKCoordinateRegion(center: pin.coordinate, latitudinalMeters: 1000000, longitudinalMeters: 1000000)
        mapView.addGestureRecognizer(gestureRecognizer)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.addAnnotation(pin)
    }
    
    private func setupCardView() {
        let cardViewModel = CardViewModel(delegate: self)
        cardView.setupCardView(with: cardViewModel)
        mapView.addSubview(cardView)
        setupCardConstraints()
    }
    
    private func setupCardConstraints() {
        cardView.snp.makeConstraints { make in
            make.left.equalTo(mapView).offset(20)
            make.right.equalTo(mapView).offset(-20)
            make.bottom.equalTo(mapView).offset(200)
            make.height.equalTo(200)
        }
    }
    
    private func showCard() {
        UIView.animate(withDuration: 0.2) {
            self.cardView.snp.remakeConstraints { make in
                make.left.equalTo(self.mapView).offset(20)
                make.right.equalTo(self.mapView).offset(-20)
                make.bottom.equalTo(self.mapView).offset(-20)
                make.height.equalTo(200)
            }
            self.view.layoutIfNeeded()
        }
    }

    private func closeCard() {
        UIView.animate(withDuration: 0.2) {
            self.cardView.snp.remakeConstraints { make in
                make.left.equalTo(self.mapView).offset(20)
                make.right.equalTo(self.mapView).offset(-20)
                make.bottom.equalTo(self.mapView).offset(200)
                make.height.equalTo(200)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func showCardOnCenterOfScreen() {
        UIView.animate(withDuration: 0.2) {
            self.cardView.snp.remakeConstraints { make in
                make.left.equalTo(self.mapView).offset(20)
                make.right.equalTo(self.mapView).offset(-20)
                make.center.equalTo(self.mapView.center)
                make.height.equalTo(200)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func showError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
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
    guard let text = searchController.searchBar.text else { return }
    guard !text.isEmpty else { return }
    viewModel.selectedCity = text
    viewModel.getCoordinates(for: text)
  }
}

extension MapViewController: CardViewModelDelegate {
    func cardViewModelDidTapClose() {
        closeCard()
    }
    
    func cardViewModelDidTapShowWeather(_ viewModel: CardViewModel) {
        guard let city = self.viewModel.selectedCity else { return }
        self.viewModel.delegate?.mapViewModel(self.viewModel, didRequestShowWeatherFor: city)
    }
}

extension MapViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        keyboardIsOpened = true
        showCardOnCenterOfScreen()
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        keyboardIsOpened = false
        showCard()
    }
}
