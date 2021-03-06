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
            guard let url = URL(string: URLFactory.iconBaseURL +
                            (self.viewModel.weatherState.icon ?? "01n")
                            + "@2x.png") else { return }
            let imageName = self.viewModel.weatherState.state ?? "Clear"
            self.cityLabel.text = self.viewModel.cityName
            self.temperatureLabel.text = self.viewModel.weatherState.temperature
            self.humidityLabel.text = self.viewModel.weatherState.humidity
            self.windLabel.text = self.viewModel.weatherState.windSpeed
            self.pressureLabel.text = self.viewModel.weatherState.pressure
            self.weatherStateLabel.text = self.viewModel.weatherState.state
            self.setWeatherStateImageView(imageName)
            self.weatherStateIcon.kf.setImage(with: url)
        }
        
        viewModel.onDidError = { [weak self] in
            guard let error = self?.viewModel.error else { return }
            self?.showError(error)
        }
    }
    
    private func setWeatherStateImageView(_ imageName: String) {
        guard let image = UIImage(named: imageName) else { return }
        weatherStateImage.image = image
    }
    
    private func showError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
