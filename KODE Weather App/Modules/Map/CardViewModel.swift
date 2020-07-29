//
//  CardViewModel.swift

import MapKit

protocol CardViewModelDelegate: class {
    func cardViewModelDidTapClose(_ viewModel: CardViewModel)
    func cardViewModelDidTapShowWeather(_ viewModel: CardViewModel)
}

class CardViewModel {
    weak var delegate: CardViewModelDelegate?
    
    var city = String()
    var coordinatesString = String()
    var coordinates = CLLocationCoordinate2D()
    
    var onDidUpdate: (() -> Void)?
    
    init(delegate: CardViewModelDelegate) {
        self.delegate = delegate
    }
    
    func onCloseButton() {
        delegate?.cardViewModelDidTapClose(self)
    }
    
    func onShowWeather() {
        delegate?.cardViewModelDidTapShowWeather(self)
    }
}
