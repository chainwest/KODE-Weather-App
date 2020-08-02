//
//  CardView.swift

import UIKit
import SnapKit

class CardView: UIView {
    var viewModel: CardViewModel?
    
    @IBOutlet var contentView: UIView! {
        didSet {
            contentView.layer.masksToBounds = true
            contentView.layer.cornerRadius = 16
            contentView.layer.shadowColor = UIColor.black.cgColor
            contentView.layer.shadowOpacity = 0.5
            contentView.layer.shadowOffset = .zero
            contentView.layer.shadowRadius = 10
        }
    }
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var shoWeatherButton: UIButton! {
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
    
    @IBAction func onCloseButton(_ sender: Any) {
        viewModel?.onCloseButton()
    }
    
    @IBAction func onShowWeatherButton(_ sender: Any) {
        viewModel?.onShowWeather()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("CardView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func setupCardView(with viewModel: CardViewModel) {
        self.viewModel = viewModel
    }
}
