//
//  WeatherViewController.swift

import UIKit
import Alamofire
import Kingfisher

class WeatherViewController: UIViewController {
    let viewModel: WeatherViewModel
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherStateIcon: UIImageView!
    @IBOutlet weak var weatherStateLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var weatherStateImage: UIImageView!
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
        viewModel.getWeather()
    }
    
    func bindToViewModel() {
        viewModel.onDidUpdate = { [weak self] in
            let url = URL(string: URLFactory.iconBaseURL + (self?.viewModel.icon)! + "@2x.png")
            self?.cityLabel.text = self?.viewModel.cityName
            self?.temperatureLabel.text = self?.viewModel.temperature
            self?.humidityLabel.text = self?.viewModel.humidity
            self?.windLabel.text = self?.viewModel.windSpeed
            self?.pressureLabel.text = self?.viewModel.pressure
            self?.weatherStateLabel.text = self?.viewModel.weatherDescription
            self?.weatherStateIcon.kf.setImage(with: url)
        }
    }
}
