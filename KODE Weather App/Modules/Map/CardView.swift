//
//  CardView.swift

import UIKit

class CardView: UIView {
    var viewModel: CardViewModel?
    
    @IBOutlet var contentView: UIView! {
        didSet {
            contentView.layer.masksToBounds = true
            contentView.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var showWeatherButton: UIButton! {
        didSet {
            showWeatherButton.layer.masksToBounds = true
            showWeatherButton.layer.cornerRadius = 22
            showWeatherButton.layer.borderWidth = 1
            showWeatherButton.layer.borderColor = showWeatherButton.tintColor.cgColor
        }
    }
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
      super.init(frame: frame)
    }
    
    func setup(with viewModel: CardViewModel) {
      self.viewModel = viewModel
    }
    
    @IBAction func closeButtonDidTapped(_ sender: Any) {
        viewModel?.onCloseButton()
    }
    
    @IBAction func showWeatherButtonDidTapped(_ sender: Any) {
        viewModel?.onShowWeather()
    }
}
