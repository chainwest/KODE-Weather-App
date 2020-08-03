//
//  CardView.swift

import UIKit
import SnapKit

class CardView: UIView {
    private var viewModel: CardViewModel?
    
    @IBOutlet private var contentView: UIView! {
        didSet {
            contentView.layer.masksToBounds = true
            contentView.layer.cornerRadius = 16
            contentView.layer.shadowColor = UIColor.black.cgColor
            contentView.layer.shadowOpacity = 0.5
            contentView.layer.shadowOffset = .zero
            contentView.layer.shadowRadius = 10
        }
    }
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var coordinatesLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var shoWeatherButton: UIButton! {
        didSet {
            shoWeatherButton.layer.masksToBounds = true
            shoWeatherButton.layer.cornerRadius = 22
            shoWeatherButton.layer.borderWidth = 1
            shoWeatherButton.layer.borderColor = closeButton.tintColor.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        commonInit()
    }
    
    @IBAction private func onCloseButton(_ sender: Any) {
        viewModel?.onCloseButton()
    }
    
    @IBAction private func onShowWeatherButton(_ sender: Any) {
        viewModel?.onShowWeather()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("CardView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    public func setupCardView(with viewModel: CardViewModel) {
        self.viewModel = viewModel
    }
    
    public func setCityAndCoordinates(_ city: String?, _ coordinates: String?) {
        self.cityLabel.text = city
        self.coordinatesLabel.text = coordinates
    }
}
