//
//  WeatherViewController.swift

import UIKit
import Kingfisher

class WeatherViewController: UIViewController {
    let viewModel: WeatherViewModel
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getWeather()
        bindToViewModel()
    }
    
    func bindToViewModel() {
        viewModel.onDidUpdate = { [weak self] in
            let url = URL(string: URLFactory.baseURL + "img/wn/" + (self?.viewModel.icon)! + "@2x.png")
            self?.cityLabel.text = self?.viewModel.cityName
            self?.temperatureLabel.text = self?.viewModel.temperature
            self?.humidity.text = self?.viewModel.humidity
            self?.windSpeed.text = self?.viewModel.windSpeed
            self?.pressure.text = self?.viewModel.pressure
            self?.weatherDescription.text = self?.viewModel.weatherDescription
            self?.weatherIcon.kf.setImage(with: url)
        }
    }

}
