//
//  CardViewModel.swift

import MapKit

protocol CardViewModelDelegate: class {
    func cardViewModelDidTapClose()
    func cardViewModelDidTapShowWeather(_ viewModel: CardViewModel)
}

class CardViewModel {
    weak var delegate: CardViewModelDelegate?
    
    var city = String()
    var coordinatesString = String()
    var coordinates = CLLocationCoordinate2D()
    var cardIsOpened = false
    
    init(delegate: CardViewModelDelegate) {
        self.delegate = delegate
    }
    
    func onCloseButton() {
        delegate?.cardViewModelDidTapClose()
    }
    
    func onShowWeather() {
        delegate?.cardViewModelDidTapShowWeather(self)
    }
}
