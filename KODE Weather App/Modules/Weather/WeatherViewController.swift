//
//  WeatherViewController.swift

import UIKit
import Alamofire
import Kingfisher

class WeatherViewController: UIViewController {
    private let viewModel: WeatherViewModel
    
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var weatherStateIcon: UIImageView!
    @IBOutlet private weak var weatherStateLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var windLabel: UILabel!
    @IBOutlet private weak var pressureLabel: UILabel!
    @IBOutlet private weak var weatherStateImage: UIImageView!
    
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
    
    private func bindToViewModel() {
        viewModel.onDidUpdate = { [weak self] in
            guard let self = self else { return }
            let url = URL(string: URLFactory.iconBaseURL + (self.viewModel.icon) + "@2x.png")
            let myid = self.viewModel.id
            self.cityLabel.text = self.viewModel.cityName
            self.temperatureLabel.text = self.viewModel.temperature
            self.humidityLabel.text = self.viewModel.humidity
            self.windLabel.text = self.viewModel.windSpeed
            self.pressureLabel.text = self.viewModel.pressure
            self.weatherStateLabel.text = self.viewModel.weatherDescription
            self.setupWeatherConditionImage(myid)
            self.weatherStateIcon.kf.setImage(with: url)
        }
    }
    
    private func setupWeatherConditionImage(_ id: Int) {
        switch id {
        case 200...232:
            self.weatherStateImage.image = UIImage(named: "Thunderstorm")
        case 300...321:
            self.weatherStateImage.image = UIImage(named: "Drizzle")
        case 500...531:
            self.weatherStateImage.image = UIImage(named: "Rain")
        case 600...622:
            self.weatherStateImage.image = UIImage(named: "Snow")
        case 701...781:
            self.weatherStateImage.image = UIImage(named: "Thunderstorm")
        case 800:
            self.weatherStateImage.image = UIImage(named: "Clear")
        case 801...804:
            self.weatherStateImage.image = UIImage(named: "Clouds")
        default:
            self.weatherStateImage.image = UIImage(named: "Clear")
        }
    }
}
