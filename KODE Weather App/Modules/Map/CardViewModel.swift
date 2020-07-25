//
//  CardViewModel.swift

import Foundation

protocol CardViewModelDelegate: class {
    func cardViewModelDidTapClose(_ viewModel: CardViewModel)
    func cardViewModelDidTapShowWeather(_ viewModel: CardViewModel)
}

class CardViewModel {
    weak var delegate: CardViewModelDelegate?
    
    private(set) var city = ""
    private(set) var coordinates = ""
    
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
