//
//  CardViewModel.swift

import MapKit

protocol CardViewModelDelegate: class {
    func cardViewModelDidTapClose(_ viewModel: CardViewModel)
    func cardViewModelDidTapShowWeather(_ viewModel: CardViewModel)
}

class CardViewModel {
    weak var delegate: CardViewModelDelegate?
    
    init(delegate: CardViewModelDelegate) {
        self.delegate = delegate
    }
    
    public func onCloseButton() {
        delegate?.cardViewModelDidTapClose(self)
    }
    
    public func onShowWeather() {
        delegate?.cardViewModelDidTapShowWeather(self)
    }
}
